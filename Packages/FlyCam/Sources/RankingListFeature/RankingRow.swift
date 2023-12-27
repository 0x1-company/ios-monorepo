import ComposableArchitecture
import SwiftUI

@Reducer
public struct RankingRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    let rank: Int
    let altitude: Double
    let displayName: String

    public var id: String {
      return rank.description
    }

    public init(rank: Int, altitude: Double, displayName: String) {
      self.rank = rank
      self.altitude = altitude
      self.displayName = displayName
    }
  }

  public enum Action {
    case onTask
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        return .none
      }
    }
  }
}

public struct RankingRowView: View {
  let store: StoreOf<RankingRowLogic>

  public init(store: StoreOf<RankingRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 0) {
        HStack(spacing: 0) {
          VStack(spacing: 4) {
            Text("No.\(viewStore.rank): \(viewStore.altitude) meter", bundle: .module)
              .frame(maxWidth: .infinity, alignment: .leading)

            Text("by \(viewStore.displayName)", bundle: .module)
              .foregroundStyle(Color.secondary)
              .frame(maxWidth: .infinity, alignment: .leading)
          }
          .font(.system(.subheadline, weight: .semibold))

          Image(systemName: "ellipsis")
            .foregroundStyle(Color.secondary)
        }
        .frame(height: 56)
        .padding(.horizontal, 16)

        Color.red
          .aspectRatio(3 / 4, contentMode: .fit)
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .compositingGroup()
      }
    }
  }
}

#Preview {
  RankingRowView(
    store: .init(
      initialState: RankingRowLogic.State(
        rank: 1,
        altitude: 1.0,
        displayName: "tomokisun"
      ),
      reducer: { RankingRowLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
}
