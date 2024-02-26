import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import MatchedFeature
import Styleguide
import SwiftUI
import SwipeCardFeature
import SwipeFeature

@Reducer
public struct ReceivedLikeSwipeLogic {
  public init() {}

  public struct State: Equatable {
    var child = Child.State.loading

    public init() {}
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case emptyButtonTapped
    case usersByLikerResponse(Result<BeMatch.UsersByLikerQuery.Data, Error>)
    case child(Child.Action)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.usersByLiker) var usersByLiker

  enum Cancel: Hashable {
    case usersByLiker
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.child, action: \.child, child: Child.init)
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ReceivedLikeSwipe", of: self)
        return .run { send in
          for try await data in usersByLiker() {
            await send(.usersByLikerResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.usersByLikerResponse(.failure(error)))
        }

      case .closeButtonTapped:
        return .send(.delegate(.dismiss))

      case .emptyButtonTapped:
        return .send(.delegate(.dismiss))

      case let .usersByLikerResponse(.success(data)):
        let rows = data.usersByLiker
          .map(\.fragments.swipeCard)
          .filter { !$0.images.isEmpty }

        state.child = .content(SwipeLogic.State(rows: rows))
        return .none

      case .usersByLikerResponse(.failure):
        return .send(.delegate(.dismiss))

      case .child(.content(.delegate(.finished))):
        state.child = .empty
        return .none

      default:
        return .none
      }
    }
  }

  @Reducer
  public struct Child {
    public enum State: Equatable {
      case loading
      case empty
      case content(SwipeLogic.State)
    }

    public enum Action {
      case loading
      case empty
      case content(SwipeLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.content, action: \.content, child: SwipeLogic.init)
    }
  }
}

public struct ReceivedLikeSwipeView: View {
  let store: StoreOf<ReceivedLikeSwipeLogic>

  public init(store: StoreOf<ReceivedLikeSwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
      switch initialState {
      case .loading:
        Color.black
          .overlay {
            ProgressView()
              .tint(Color.white)
          }

      case .empty:
        emptyView

      case .content:
        CaseLet(
          /ReceivedLikeSwipeLogic.Child.State.content,
          action: ReceivedLikeSwipeLogic.Child.Action.content,
          then: SwipeView.init(store:)
        )
      }
    }
    .navigationTitle(String(localized: "See who likes you", bundle: .module))
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "chevron.down")
            .bold()
            .foregroundStyle(Color.white)
            .frame(width: 44, height: 44)
        }
      }
    }
  }

  private var emptyView: some View {
    VStack(spacing: 24) {
      Image(ImageResource.empty)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 120)

      Text("Looks like he's gone.", bundle: .module)
        .font(.system(.title3, weight: .semibold))

      PrimaryButton(
        String(localized: "Swipe others", bundle: .module)
      ) {
        store.send(.emptyButtonTapped)
      }
    }
    .padding(.horizontal, 16)
    .multilineTextAlignment(.center)
  }
}

#Preview {
  ReceivedLikeSwipeView(
    store: .init(
      initialState: ReceivedLikeSwipeLogic.State(),
      reducer: { ReceivedLikeSwipeLogic() }
    )
  )
}
