import AnalyticsClient
import API
import BannerFeature
import ComposableArchitecture
import SwiftUI

@Reducer
public struct RankingListLogic {
  public init() {}

  public struct State: Equatable {
    var banners: IdentifiedArrayOf<BannerCardLogic.State>
    var rows: IdentifiedArrayOf<RankingRowLogic.State>

    var empty: RankingEmptyLogic.State?

    public init(
      banners: IdentifiedArrayOf<BannerCardLogic.State>,
      rows: IdentifiedArrayOf<RankingRowLogic.State>
    ) {
      self.banners = banners
      self.rows = rows
      empty = rows.isEmpty ? .init() : nil
    }
  }

  public enum Action {
    case onTask
    case banners(IdentifiedActionOf<BannerCardLogic>)
    case rows(IdentifiedActionOf<RankingRowLogic>)
    case empty(RankingEmptyLogic.Action)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none

      default:
        return .none
      }
    }
    .forEach(\.banners, action: \.banners) {
      BannerCardLogic()
    }
    .forEach(\.rows, action: \.rows) {
      RankingRowLogic()
    }
    .ifLet(\.empty, action: \.empty) {
      RankingEmptyLogic()
    }
  }
}

public struct RankingListView: View {
  let store: StoreOf<RankingListLogic>

  public init(store: StoreOf<RankingListLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      ScrollView {
        LazyVStack(spacing: 24) {
          ForEachStore(
            store.scope(state: \.banners, action: \.banners),
            content: BannerCardView.init(store:)
          )

          ForEachStore(
            store.scope(state: \.rows, action: \.rows),
            content: RankingRowView.init(store:)
          )
        }
      }
      .task { await store.send(.onTask).finish() }
      .overlay {
        IfLetStore(
          store.scope(state: \.empty, action: \.empty),
          then: RankingEmptyView.init(store:)
        )
      }
    }
  }
}

#Preview {
  NavigationStack {
    RankingListView(
      store: .init(
        initialState: RankingListLogic.State(
          banners: [],
          rows: []
        ),
        reducer: { RankingListLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
