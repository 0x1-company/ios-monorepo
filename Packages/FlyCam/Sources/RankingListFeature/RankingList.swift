import AnalyticsClient
import BannerFeature
import ComposableArchitecture
import FlyCam
import SwiftUI

@Reducer
public struct RankingListLogic {
  public init() {}

  public struct State: Equatable {
    let banners: IdentifiedArrayOf<BannerCardLogic.State>

    var empty: RankingEmptyLogic.State?

    public init(
      banners: IdentifiedArrayOf<BannerCardLogic.State>
    ) {
      self.banners = banners
    }
  }

  public enum Action {
    case onTask
    case banners(IdentifiedActionOf<BannerCardLogic>)
    case empty(RankingEmptyLogic.Action)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        state.empty = .init()
        return .none

      default:
        return .none
      }
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

          VStack(spacing: 12) {
            Color.red
              .aspectRatio(3 / 4, contentMode: .fit)
              .frame(width: 114)
              .clipShape(RoundedRectangle(cornerRadius: 16))
              .frame(maxWidth: .infinity, alignment: .center)

            Button {} label: {
              Image(systemName: "square.and.arrow.up")
                .font(.footnote)
                .fontWeight(.semibold)
                .frame(width: 44, height: 44)
                .foregroundStyle(Color.primary)
                .background(Color(uiColor: UIColor.tertiarySystemBackground))
                .clipShape(Circle())
            }
          }

          IfLetStore(
            store.scope(state: \.empty, action: \.empty),
            then: RankingEmptyView.init(store:)
          )

          ForEach(0 ..< 100) { index in
            RankingRowView(
              rank: index + 1,
              altitude: 4.0,
              displayName: "tomokisun"
            )
          }
        }
      }
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    RankingListView(
      store: .init(
        initialState: RankingListLogic.State(
          banners: []
        ),
        reducer: { RankingListLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
