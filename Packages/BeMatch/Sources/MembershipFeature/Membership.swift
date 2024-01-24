import ActivityView
import AnalyticsClient
import BeMatch
import BeMatchClient
import Build
import ComposableArchitecture
import StoreKit
import StoreKitClient
import StoreKitHelpers
import SwiftUI
import TcaHelpers

@Reducer
public struct MembershipLogic {
  public init() {}

  public struct CompletionWithItems: Equatable {
    public let activityType: UIActivity.ActivityType?
    public let result: Bool
  }

  public struct State: Equatable {
    var child: Child.State?
    var isActivityIndicatorVisible = false

    let bematchProOneWeekId: String
    var appAccountToken: UUID?
    var product: StoreKit.Product?

    var invitationCode = ""

    @BindingState var isPresented = false
    @PresentationState var destination: Destination.State?

    var shareText = ""

    public init() {
      @Dependency(\.build) var build
      bematchProOneWeekId = build.infoDictionary("BEMATCH_PRO_ID", for: String.self)!
    }
  }

  public enum Action: BindableAction {
    case onTask
    case closeButtonTapped
    case response(Result<[Product], Error>, Result<BeMatch.MembershipQuery.Data, Error>)
    case purchaseResponse(Result<StoreKit.Transaction, Error>)
    case createAppleSubscriptionResponse(Result<BeMatch.CreateAppleSubscriptionMutation.Data, Error>)
    case transactionFinish(StoreKit.Transaction)
    case onCompletion(CompletionWithItems)
    case child(Child.Action)
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.build) var build
  @Dependency(\.store) var store
  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case purchase
    case response
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { [id = state.bematchProOneWeekId] send in
          for try await data in bematch.membership() {
            await send(.response(Result {
              try await store.products([id])
            }, .success(data)))
          }
        } catch: { error, send in
          await send(.response(.success([]), .failure(error)))
        }
        .cancellable(id: Cancel.response, cancelInFlight: true)

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      case .child(.campaign(.delegate(.sendInvitationCode))),
           .child(.campaign(.invitationCodeCampaign(.delegate(.sendInvitationCode)))):
        state.isPresented = true
        return .none

      case .child(.campaign(.delegate(.purchase))),
           .child(.purchase(.delegate(.purchase))):
        guard
          let product = state.product,
          let appAccountToken = state.appAccountToken
        else { return .none }

        state.isActivityIndicatorVisible = true

        return .run { send in
          let result = try await store.purchase(product, appAccountToken)

          switch result {
          case let .success(verificationResult):
            await send(.purchaseResponse(Result {
              try checkVerified(verificationResult)
            }))

          case .pending:
            await send(.purchaseResponse(.failure(InAppPurchaseError.pending)))
          case .userCancelled:
            await send(.purchaseResponse(.failure(InAppPurchaseError.userCancelled)))
          @unknown default:
            fatalError()
          }
        } catch: { error, send in
          await send(.purchaseResponse(.failure(error)))
        }
        .cancellable(id: Cancel.purchase, cancelInFlight: true)

      case let .response(.success(products), .success(data)):
        let userId = data.currentUser.id
        state.appAccountToken = UUID(uuidString: userId)
        state.invitationCode = data.invitationCode.code

        let campaign = data.activeInvitationCampaign
        let product = products.first(where: { $0.id == state.bematchProOneWeekId })
        state.product = product

        if let campaign, let product {
          state.child = .campaign(
            MembershipCampaignLogic.State(
              campaign: campaign,
              code: data.invitationCode.code,
              displayPrice: product.displayPrice,
              displayDuration: formatDuration(campaign.durationWeeks)
            )
          )

          let price = campaign.durationWeeks * 500

          let localizationValue: String.LocalizationValue = """
          I gave you an invitation code [\(data.invitationCode.code)] for free BeMatch PRO worth \(price) yen! 🎁.

          When you become a BeMatch PRO...
          ■ See who you are Liked by.

          BeReal exchange app "BeMatch." Download it! 🤞🏻
          https://bematch.onelink.me/nob4/mhxumci1
          """
          state.shareText = String(localized: localizationValue, bundle: .module)

        } else if let product {
          state.child = .purchase(
            MembershipPurchaseLogic.State(
              displayPrice: product.displayPrice
            )
          )
        }
        return .none

      case let .purchaseResponse(.success(transaction)):
        state.isActivityIndicatorVisible = false
        if transaction.environment == .xcode {
          return .run { send in
            await send(.transactionFinish(transaction))
          }
        }
        let isProduction = transaction.environment == .production
        let environment: BeMatch.AppleSubscriptionEnvironment = isProduction ? .production : .sandbox
        let input = BeMatch.CreateAppleSubscriptionInput(
          environment: GraphQLEnum(environment),
          transactionId: transaction.id.description
        )
        return .run { send in
          let data = try await bematch.createAppleSubscription(input)
          guard data.createAppleSubscription else { return }
          await send(.transactionFinish(transaction))
        } catch: { error, send in
          await send(.createAppleSubscriptionResponse(.failure(error)))
        }

      case .purchaseResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .createAppleSubscriptionResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case let .onCompletion(completion):
        state.isPresented = false
        analytics.logEvent("invitation_code_completion", [
          "activity_type": completion.activityType?.rawValue,
          "result": completion.result,
        ])
        return .none

      case let .transactionFinish(transaction):
        state.destination = .alert(
          AlertState {
            TextState("I joined BeMatch PRO", bundle: .module)
          } actions: {
            ButtonState(action: .confirmOkay) {
              TextState("OK", bundle: .module)
            }
          }
        )
        return .run { _ in
          await transaction.finish()
        }

      case .destination(.presented(.alert(.confirmOkay))):
        state.destination = nil
        return .send(.delegate(.dismiss))

      default:
        return .none
      }
    }
    .ifLet(\.child, action: \.child) {
      Child()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  func formatDuration(_ durationWeeks: Int) -> String {
    if durationWeeks <= 3 {
      return String(localized: "\(durationWeeks) week", bundle: .module)
    }

    let months = durationWeeks / 4
    let remainingWeeks = durationWeeks % 4

    let years = months / 12
    let remainingMonths = months % 12

    var result: [String] = []
    if years > 0 {
      result.append(String(localized: "\(years) year", bundle: .module))
    }
    if remainingMonths > 0 {
      result.append(String(localized: "\(remainingMonths) month", bundle: .module))
    }
    if remainingWeeks > 0 {
      result.append(String(localized: "\(remainingWeeks) week", bundle: .module))
    }

    return result.joined(separator: ", ")
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case campaign(MembershipCampaignLogic.State)
      case purchase(MembershipPurchaseLogic.State)
    }

    public enum Action {
      case campaign(MembershipCampaignLogic.Action)
      case purchase(MembershipPurchaseLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.campaign, action: \.campaign) {
        MembershipCampaignLogic()
      }
      Scope(state: \.purchase, action: \.purchase) {
        MembershipPurchaseLogic()
      }
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case alert(AlertState<Action.Alert>)
    }

    public enum Action {
      case alert(Alert)

      public enum Alert: Equatable {
        case confirmOkay
      }
    }

    public var body: some Reducer<State, Action> {
      EmptyReducer()
    }
  }
}

public struct MembershipView: View {
  let store: StoreOf<MembershipLogic>

  public init(store: StoreOf<MembershipLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      IfLetStore(store.scope(state: \.child, action: \.child)) { store in
        SwitchStore(store) { initialState in
          switch initialState {
          case .campaign:
            CaseLet(
              /MembershipLogic.Child.State.campaign,
              action: MembershipLogic.Child.Action.campaign,
              then: MembershipCampaignView.init(store:)
            )
          case .purchase:
            CaseLet(
              /MembershipLogic.Child.State.purchase,
              action: MembershipLogic.Child.Action.purchase,
              then: MembershipPurchaseView.init(store:)
            )
          }
        }
      } else: {
        ProgressView()
          .tint(Color.primary)
      }
      .ignoresSafeArea()
      .task { await store.send(.onTask).finish() }
      .alert(store: store.scope(state: \.$destination.alert, action: \.destination.alert))
      .toolbar {
        if !viewStore.isActivityIndicatorVisible {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              store.send(.closeButtonTapped)
            } label: {
              Image(systemName: "xmark")
                .foregroundStyle(Color.primary)
            }
          }
        }
      }
      .overlay {
        if viewStore.isActivityIndicatorVisible {
          ProgressView()
            .tint(Color.white)
            .progressViewStyle(CircularProgressViewStyle())
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.opacity(0.6))
        }
      }
      .sheet(isPresented: viewStore.$isPresented) {
        ActivityView(
          activityItems: [viewStore.shareText],
          applicationActivities: nil
        ) { activityType, result, _, _ in
          store.send(
            .onCompletion(
              MembershipLogic.CompletionWithItems(
                activityType: activityType,
                result: result
              )
            )
          )
        }
        .presentationDetents([.medium, .large])
      }
    }
  }
}

#Preview {
  NavigationStack {
    MembershipView(
      store: .init(
        initialState: MembershipLogic.State(),
        reducer: { MembershipLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
