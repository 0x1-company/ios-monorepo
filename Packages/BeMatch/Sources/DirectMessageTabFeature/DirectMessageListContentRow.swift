import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct DirectMessageListContentRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public let id: String
    let username: String
    let imageUrl: String
    let text: String
    let isAuthor: Bool
    var isRead: Bool

    var textForegroundColor: Color {
      !isAuthor && !isRead ? Color.primary : Color.secondary
    }

    public init(messageRoom: BeMatch.DirectMessageListContentRow) {
      id = messageRoom.targetUser.id
      username = messageRoom.targetUser.berealUsername
      imageUrl = messageRoom.targetUser.images.first!.imageUrl
      text = messageRoom.latestMessage.text
      isAuthor = messageRoom.latestMessage.isAuthor
      isRead = messageRoom.latestMessage.isRead
    }
    
    mutating func read() {
      isRead = true
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

public struct DirectMessageListContentRowView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<DirectMessageListContentRowLogic>

  public init(store: StoreOf<DirectMessageListContentRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.rowButtonTapped)
      } label: {
        HStack(spacing: 8) {
          CachedAsyncImage(
            url: URL(string: viewStore.imageUrl),
            urlCache: .shared,
            scale: displayScale,
            content: { image in
              image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 72, height: 72)
            },
            placeholder: {
              Color.black
                .frame(width: 72, height: 72)
                .overlay {
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(Color.white)
                }
            }
          )
          .clipShape(Circle())

          VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 0) {
              Text(viewStore.username)
                .font(.system(.subheadline, weight: .semibold))
                .frame(maxWidth: .infinity, alignment: .leading)

              if !viewStore.isAuthor {
                Text("Let's Reply", bundle: .module)
                  .font(.system(.caption2, weight: .medium))
                  .foregroundStyle(Color.black)
                  .padding(.vertical, 3)
                  .padding(.horizontal, 6)
                  .background(Color.white)
                  .clipShape(RoundedRectangle(cornerRadius: 4))
              }
            }

            Text(viewStore.text)
              .lineLimit(1)
              .font(.body)
              .foregroundStyle(viewStore.textForegroundColor)
          }
        }
        .padding(.vertical, 8)
        .background()
        .compositingGroup()
      }
      .buttonStyle(HoldDownButtonStyle())
    }
  }
}
