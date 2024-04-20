import ActivityView
import AnalyticsClient
import API
import APIClient
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

    public init(activityType: UIActivity.ActivityType?, result: Bool) {
      self.activityType = activityType
      self.result = result
    }
  }

  public struct State: Equatable {
    public var child = Child.State.loading
    public var isActivityIndicatorVisible = false

    public let bematchProOneWeekId: String
    var appAccountToken: UUID?
    var product: StoreKit.Product?

    public var invitationCode = ""

    @BindingState public var isPresented = false
    @PresentationState public var destination: Destination.State?

    public var shareText = ""

    public init() {
      @Dependency(\.build) var build
      bematchProOneWeekId = build.infoDictionary("BEMATCH_PRO_ID", for: String.self)!
    }
  }

  public enum Action: BindableAction {
    case onTask
    case closeButtonTapped
    case response(Result<[Product], Error>, Result<API.MembershipQuery.Data, Error>)
    case purchaseResponse(Result<StoreKit.Transaction, Error>)
    case createAppleSubscriptionResponse(Result<API.CreateAppleSubscriptionMutation.Data, Error>)
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

  @Dependency(\.api) var api
  @Dependency(\.build) var build
  @Dependency(\.store) var store
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case purchase
    case response
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { [id = state.bematchProOneWeekId] send in
          for try await data in api.membership() {
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
          let productPrice = product.price
          let specialOfferPrice = productPrice * Decimal(campaign.durationWeeks)
          let currencyCode = product.priceFormatStyle.currencyCode
          let specialOfferDisplayPrice = currencyCode + specialOfferPrice.description

          state.child = .campaign(
            MembershipCampaignLogic.State(
              campaign: campaign,
              code: data.invitationCode.code,
              displayPrice: product.displayPrice,
              displayDuration: formatDuration(campaign.durationWeeks),
              currencyCode: currencyCode,
              specialOfferDisplayPrice: specialOfferDisplayPrice
            )
          )

          state.shareText = String(
            localized: """
            I gave you an invitation code [\(data.invitationCode.code)] for free BeMatch PRO worth \(specialOfferDisplayPrice)! 🎁.

            When you become a BeMatch PRO...
            ■ See who you are Liked by.

            BeReal exchange app "BeMatch." Download it! 🤞🏻
            https://bematch.onelink.me/nob4/mhxumci1
            """,
            bundle: .module
          )

        } else if let product {
          state.child = .purchase(
            MembershipPurchaseLogic.State(
              displayPrice: product.displayPrice
            )
          )
        }
        return .none

      case let .response(.success(products), .failure):
        guard let product = products.first(where: { $0.id == state.bematchProOneWeekId })
        else { return .none }

        state.child = .purchase(MembershipPurchaseLogic.State(displayPrice: product.displayPrice))
        return .none

      case let .purchaseResponse(.success(transaction)):
        state.isActivityIndicatorVisible = false
        if transaction.environment == .xcode {
          return .run { send in
            await send(.transactionFinish(transaction))
          }
        }
        let isProduction = transaction.environment == .production
        let environment: API.AppleSubscriptionEnvironment = isProduction ? .production : .sandbox
        let input = API.CreateAppleSubscriptionInput(
          environment: GraphQLEnum(environment),
          transactionId: transaction.id.description
        )
        return .run { send in
          let data = try await api.createAppleSubscription(input)
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
      case loading
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
      Scope(state: \.alert, action: \.alert) {}
    }
  }
}
