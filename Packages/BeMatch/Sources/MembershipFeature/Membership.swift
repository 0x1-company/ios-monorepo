import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipLogic {
  public init() {}

  public struct State: Equatable {
    var child: Child.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case closeButtonTapped
    case activeInvitationCampaignResponse(Result<BeMatch.ActiveInvitationCampaignQuery.Data, Error>)
    case child(Child.Action)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case activeInvitationCampaign
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          for try await data in bematch.activeInvitationCampaign() {
            await send(.activeInvitationCampaignResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.activeInvitationCampaignResponse(.failure(error)))
        }
        .cancellable(id: Cancel.activeInvitationCampaign, cancelInFlight: true)

      case .onAppear:
        analytics.logScreen(screenName: "Membership", of: self)
        return .none

      case .closeButtonTapped:
        return .run { _ in
          await dismiss()
        }

      case let .activeInvitationCampaignResponse(.success(data)):
        if let campaign = data.activeInvitationCampaign {
          state.child = .campaign(MembershipCampaignLogic.State(campaign: campaign))
        } else {
          state.child = .purchase(MembershipPurchaseLogic.State())
        }
        return .none

      case .activeInvitationCampaignResponse(.failure):
        state.child = .purchase(MembershipPurchaseLogic.State())
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.child, action: \.child) {
      Child()
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
    .onAppear { store.send(.onAppear) }
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
