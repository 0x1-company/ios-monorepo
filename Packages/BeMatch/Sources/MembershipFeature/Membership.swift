import AnalyticsClient
import BeMatch
import BeMatchClient
import Build
import ComposableArchitecture
import StoreKit
import StoreKitClient
import StoreKitHelpers
import SwiftUI

@Reducer
public struct MembershipLogic {
  public init() {}

  public struct State: Equatable {
    var child: Child.State?
    var isActivityIndicatorVisible = false

    let bematchProOneWeekId: String
    var product: StoreKit.Product?

    public init() {
      @Dependency(\.build) var build
      bematchProOneWeekId = build.infoDictionary("BEMATCH_PRO_ID", for: String.self)!
    }
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case productsResponse(Result<[Product], Error>)
    case membershipResponse(Result<BeMatch.MembershipQuery.Data, Error>)
    case purchaseResponse(Result<StoreKit.Transaction, Error>)
    case child(Child.Action)
  }

  @Dependency(\.build) var build
  @Dependency(\.store) var store
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case products
    case purchase
    case membership
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { [id = state.bematchProOneWeekId] send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              await productsRequest(send: send, ids: [id])
            }

            group.addTask {
              await membershipRequest(send: send)
            }
          }
        }

      case .closeButtonTapped:
        return .run { _ in
          await dismiss()
        }

      case .child(.campaign(.delegate(.purchase))):
        let appAccountToken = UUID()
        guard let product = state.product
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

      case let .productsResponse(.success(products)):
        guard
          let product = products.first(where: { $0.id == state.bematchProOneWeekId })
        else { return .none }
        state.product = product
        return .none

      case let .membershipResponse(.success(data)):
        let campaign = data.activeInvitationCampaign
        let invitationCode = data.invitationCode

        if let campaign {
          state.child = .campaign(
            MembershipCampaignLogic.State(
              campaign: campaign,
              code: invitationCode.code
            )
          )
        } else {
          state.child = .purchase(
            MembershipPurchaseLogic.State()
          )
        }
        return .none

      case .membershipResponse(.failure):
        state.child = .purchase(MembershipPurchaseLogic.State())
        return .none

      case let .purchaseResponse(.success(transaction)):
        state.isActivityIndicatorVisible = false
        return .none

      case .purchaseResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.child, action: \.child) {
      Child()
    }
  }

  func productsRequest(send: Send<Action>, ids: [String]) async {
    await withTaskCancellation(id: Cancel.products, cancelInFlight: true) {
      await send(.productsResponse(Result {
        try await store.products(ids)
      }))
    }
  }

  func membershipRequest(send: Send<Action>) async {
    await withTaskCancellation(id: Cancel.membership, cancelInFlight: true) {
      do {
        for try await data in bematch.membership() {
          await send(.membershipResponse(.success(data)))
        }
      } catch {
        await send(.membershipResponse(.failure(error)))
      }
    }
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
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "xmark")
              .foregroundStyle(Color.primary)
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
