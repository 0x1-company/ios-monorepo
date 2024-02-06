import BeMatch
import BeMatchClient
import ComposableArchitecture
import MatchedFeature
import ReportFeature
import SwiftUI
import SwipeCardFeature
import TcaHelpers

@Reducer
public struct SwipeLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?

    var rows: IdentifiedArrayOf<SwipeCardLogic.State> = []

    public init(rows: [BeMatch.SwipeCard]) {
      self.rows = IdentifiedArrayOf(
        uniqueElements: rows.map(SwipeCardLogic.State.init)
      )
    }
  }

  public enum Action {
    case nopeButtonTapped
    case likeButtonTapped
    case createLikeResponse(Result<BeMatch.CreateLikeMutation.Data, Error>)
    case createNopeResponse(Result<BeMatch.CreateNopeMutation.Data, Error>)
    case rows(IdentifiedActionOf<SwipeCardLogic>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case finished
    }
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  enum Cancel: Hashable {
    case feedback(String)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .nopeButtonTapped:
        guard let last = state.rows.last else { return .none }
        state.rows.remove(id: last.data.id)
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await createNope(send: send, targetUserId: last.data.id)
        }

      case .likeButtonTapped:
        guard let last = state.rows.last else { return .none }
        state.rows.remove(id: last.data.id)
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await createLike(send: send, targetUserId: last.data.id)
        }

      case let .rows(.element(id, .delegate(.nope))):
        state.rows.remove(id: id)
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await createNope(send: send, targetUserId: id)
        }

      case let .rows(.element(id, .delegate(.like))):
        state.rows.remove(id: id)
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await createLike(send: send, targetUserId: id)
        }

      case let .rows(.element(id, .delegate(.report))):
        state.destination = .report(ReportLogic.State(targetUserId: id))
        return .none

      case let .createLikeResponse(.success(data)):
        guard let match = data.createLike.match else { return .none }
        let username = match.targetUser.berealUsername
        state.destination = .matched(MatchedLogic.State(username: username))
        return .none

      default:
        return .none
      }
    }
    .onChange(of: \.rows) { rows, _, _ in
      rows.isEmpty
        ? Effect<Action>.send(.delegate(.finished), animation: .default)
        : Effect<Action>.none
    }
    .forEach(\.rows, action: \.rows) {
      SwipeCardLogic()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  private func createNope(send: Send<Action>, targetUserId: String) async {
    let input = BeMatch.CreateNopeInput(targetUserId: targetUserId)
    await withTaskCancellation(id: Cancel.feedback(input.targetUserId), cancelInFlight: true) {
      await send(.createNopeResponse(Result {
        try await bematch.createNope(input)
      }))
    }
  }

  private func createLike(send: Send<Action>, targetUserId: String) async {
    let input = BeMatch.CreateLikeInput(targetUserId: targetUserId)
    await withTaskCancellation(id: Cancel.feedback(input.targetUserId), cancelInFlight: true) {
      await send(.createLikeResponse(Result {
        try await bematch.createLike(input)
      }))
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case report(ReportLogic.State)
      case matched(MatchedLogic.State)
    }

    public enum Action {
      case report(ReportLogic.Action)
      case matched(MatchedLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.report, action: \.report, child: ReportLogic.init)
      Scope(state: \.matched, action: \.matched, child: MatchedLogic.init)
    }
  }
}

public struct SwipeView: View {
  let store: StoreOf<SwipeLogic>

  public init(store: StoreOf<SwipeLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      ZStack {
        ForEachStore(
          store.scope(state: \.rows, action: \.rows),
          content: SwipeCardView.init(store:)
        )
      }

      HStack(spacing: 40) {
        Button {
          store.send(.nopeButtonTapped)
        } label: {
          Image(ImageResource.xmark)
            .resizable()
            .frame(width: 56, height: 56)
            .clipShape(Circle())
        }

        Button {
          store.send(.likeButtonTapped)
        } label: {
          Image(ImageResource.heart)
            .resizable()
            .frame(width: 56, height: 56)
            .clipShape(Circle())
        }
      }

      Spacer()
    }
    .padding(.top, 16)
    .fullScreenCover(
      store: store.scope(state: \.$destination.matched, action: \.destination.matched),
      content: MatchedView.init(store:)
    )
    .sheet(store: store.scope(state: \.$destination.report, action: \.destination.report)) { store in
      NavigationStack {
        ReportView(store: store)
      }
    }
  }
}

#Preview {
  NavigationStack {
    SwipeView(
      store: .init(
        initialState: SwipeLogic.State(rows: []),
        reducer: SwipeLogic.init
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
