import AVKit
import AVPlayerNotificationClient
import ComposableArchitecture
import FlyCam
import SwiftUI

@Reducer
public struct RankingRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public let id: String
    let rank: Int
    let altitude: Double
    let displayName: String

    let player: AVPlayer

    public init(state: EnumeratedSequence<[FlyCam.RankingRow]>.Iterator.Element) {
      id = state.element.id
      rank = state.offset + 1
      altitude = state.element.altitude
      displayName = state.element.user.displayName
      let videoURL = URL(string: state.element.videoUrl)!
      player = AVPlayer(url: videoURL)
    }
  }

  public enum Action {
    case onTask
    case didPlayToEndTime
  }

  @Dependency(\.avplayerNotification.didPlayToEndTimeNotification) var didPlayToEndTimeNotification

  enum Cancel {
    case didPlayToEndTimeNotification
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        state.player.play()
        return .run { send in
          for await _ in didPlayToEndTimeNotification() {
            await send(.didPlayToEndTime)
          }
        }
        .cancellable(id: Cancel.didPlayToEndTimeNotification, cancelInFlight: true)

      case .didPlayToEndTime:
        state.player.seek(to: CMTime.zero)
        state.player.play()
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

        VideoPlayer(player: viewStore.player)
          .aspectRatio(3 / 4, contentMode: .fill)
          .frame(width: UIScreen.main.bounds.width)
          .clipShape(RoundedRectangle(cornerRadius: 16))
          .disabled(true)
      }
      .task { await store.send(.onTask).finish() }
    }
  }
}
