import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct PremiumLogic {
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
        analytics.logScreen(screenName: "Premium", of: self)
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
      case campaign(PremiumCampaignLogic.State)
      case purchase(PremiumPurchaseLogic.State)
    }

    public enum Action {
      case campaign(PremiumCampaignLogic.Action)
      case purchase(PremiumPurchaseLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.campaign, action: \.campaign) {
        PremiumCampaignLogic()
      }
      Scope(state: \.purchase, action: \.purchase) {
        PremiumPurchaseLogic()
      }
    }
  }
}

public struct PremiumView: View {
  let store: StoreOf<PremiumLogic>

  public init(store: StoreOf<PremiumLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .campaign:
        CaseLet(
          /PremiumLogic.Child.State.campaign,
          action: PremiumLogic.Child.Action.campaign,
          then: PremiumCampaignView.init(store:)
        )
      case .purchase:
        CaseLet(
          /PremiumLogic.Child.State.purchase,
          action: PremiumLogic.Child.Action.purchase,
          then: PremiumPurchaseView.init(store:)
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
  PremiumView(
    store: .init(
      initialState: PremiumLogic.State(),
      reducer: { PremiumLogic() }
    )
  )
}
