import AnalyticsClient
import ComposableArchitecture
import DirectMessageFeature
import SwiftUI

@Reducer
public struct DirectMessageListLogic {
  public init() {}

  public struct State: Equatable {
    var child: Child.State?
    @PresentationState var destination: Destination.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case child(Child.Action)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DirectMessageList", of: self)
        return .none

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

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case content(MessageContentLogic.State)
    }

    public enum Action {
      case content(MessageContentLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.content, action: \.content) {
        MessageContentLogic()
      }
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case message(DirectMessageLogic.State)
    }

    public enum Action {
      case message(DirectMessageLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.message, action: \.message) {
        DirectMessageLogic()
      }
    }
  }
}

public struct DirectMessageListView: View {
  let store: StoreOf<DirectMessageListLogic>

  public init(store: StoreOf<DirectMessageListLogic>) {
    self.store = store
  }

  public var body: some View {
    IfLetStore(store.scope(state: \.child, action: \.child)) { store in
      SwitchStore(store) { initialState in
        switch initialState {
        case .content:
          CaseLet(
            /DirectMessageListLogic.Child.State.content,
            action: DirectMessageListLogic.Child.Action.content,
            then: MessageContentView.init(store:)
          )
        }
      }
    } else: {
      ProgressView()
        .tint(Color.white)
    }
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Image(ImageResource.beMatch)
      }
    }
    .navigationDestination(
      store: store.scope(
        state: \.$destination.message,
        action: \.destination.message
      ),
      destination: DirectMessageView.init(store:)
    )
  }
}
