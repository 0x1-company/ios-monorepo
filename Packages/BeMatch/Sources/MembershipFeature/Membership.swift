import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct MembershipLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.campaign(.init())
    public init() {}
  }

  public enum Action {
    case onAppear
    case closeButtonTapped
    case child(Child.Action)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { _, action in
      switch action {
      case .onAppear:
        analytics.logScreen(screenName: "Membership", of: self)
        return .none

      case .closeButtonTapped:
        return .run { _ in
          await dismiss()
        }

      default:
        return .none
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
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
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
    .onAppear { store.send(.onAppear) }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "xmark")
        }
      }
    }
  }
}

#Preview {
  MembershipView(
    store: .init(
      initialState: MembershipLogic.State(),
      reducer: { MembershipLogic() }
    )
  )
}
