import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct UnsentDirectMessageListContentRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public let id: String
    let isRead: Bool
    let username: String
    let imageUrl: String

    init(match: BeMatch.UnsentDirectMessageListContentRow) {
      id = match.targetUser.id
      isRead = match.isRead
      username = match.targetUser.berealUsername
      imageUrl = match.targetUser.images.first!.imageUrl
    }
  }

  public enum Action {
    case rowButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case showDirectMessage(_ username: String, _ targetUserId: String)
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .rowButtonTapped:
        let username = state.username
        let targetUserId = state.id
        return .send(.delegate(.showDirectMessage(username, targetUserId)))

      default:
        return .none
      }
    }
  }
}

public struct UnsentDirectMessageListContentRowView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<UnsentDirectMessageListContentRowLogic>

  public init(store: StoreOf<UnsentDirectMessageListContentRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.rowButtonTapped)
      } label: {
        VStack(spacing: 12) {
          CachedAsyncImage(
            url: URL(string: viewStore.imageUrl),
            urlCache: .shared,
            scale: displayScale,
            content: { image in
              image
                .resizable()
                .frame(width: 90, height: 120)
            },
            placeholder: {
              Color.black
                .frame(width: 90, height: 120)
                .overlay {
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(Color.white)
                }
            }
          )
          .clipShape(RoundedRectangle(cornerRadius: 6))
          .overlay(alignment: .bottom) {
            if !viewStore.isRead {
              Color.pink
                .frame(width: 16, height: 16)
                .clipShape(Circle())
                .overlay {
                  RoundedRectangle(cornerRadius: 16 / 2)
                    .stroke(Color.white, lineWidth: 2)
                }
                .offset(y: 10)
            }
          }

          Text(viewStore.username)
            .font(.system(.subheadline, weight: .semibold))
            .foregroundStyle(Color.primary)
        }
      }
      .buttonStyle(HoldDownButtonStyle())
    }
  }
}
