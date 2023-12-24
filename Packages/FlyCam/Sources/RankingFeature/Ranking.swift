import AnalyticsClient
import BannerFeature
import ComposableArchitecture
import FlyCam
import FlyCamClient
import RankingListFeature
import SwiftUI

@Reducer
public struct RankingLogic {
  public init() {}

  public struct State: Equatable {
    var list: RankingListLogic.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case list(RankingListLogic.Action)
    case rankingResponse(Result<FlyCam.RankingQuery.Data, Error>)
  }

  @Dependency(\.flycam) var flycam
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case ranking
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          for try await data in flycam.ranking() {
            await send(.rankingResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.rankingResponse(.failure(error)))
        }
        .cancellable(id: Cancel.ranking, cancelInFlight: true)

      case .onAppear:
        analytics.logScreen(screenName: "Ranking", of: self)
        return .none

      case let .rankingResponse(.success(data)):
        let banners = data.banners
          .map(\.fragments.bannerCard)
          .map(BannerCardLogic.State.init(banner:))

        state.list = RankingListLogic.State(
          banners: IdentifiedArrayOf(uniqueElements: banners)
        )
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.list, action: \.list) {
      RankingListLogic()
    }
  }
}

public struct RankingView: View {
  let store: StoreOf<RankingLogic>

  public init(store: StoreOf<RankingLogic>) {
    self.store = store
  }

  public var body: some View {
    IfLetStore(
      store.scope(state: \.list, action: \.list),
      then: RankingListView.init(store:),
      else: {
        ProgressView()
          .tint(Color.primary)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      }
    )
    .navigationTitle(Text("Ranking", bundle: .module))
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .onAppear { store.send(.onAppear) }
  }
}

#Preview {
  NavigationStack {
    RankingView(
      store: .init(
        initialState: RankingLogic.State(),
        reducer: { RankingLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
