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
    case refresh
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
          await rankingRequest(send: send)
        }

      case .onAppear:
        analytics.logScreen(screenName: "Ranking", of: self)
        return .none
        
      case .refresh:
        return .run { send in
          await rankingRequest(send: send)
        }

      case let .rankingResponse(.success(data)):
        let banners = data.banners
          .map(\.fragments.bannerCard)
          .map(BannerCardLogic.State.init(banner:))

        let rows = data.rankingsByPost
          .map(\.fragments.rankingRow)
          .enumerated()
          .map(RankingRowLogic.State.init(state:))

        state.list = RankingListLogic.State(
          banners: IdentifiedArrayOf(uniqueElements: banners),
          rows: IdentifiedArrayOf(uniqueElements: rows)
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
  
  func rankingRequest(send: Send<Action>) async {
    await withTaskCancellation(id: Cancel.ranking, cancelInFlight: true) {
      do {
        for try await data in flycam.ranking() {
          await send(.rankingResponse(.success(data)))
        }
      } catch {
        await send(.rankingResponse(.failure(error)))
      }
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
