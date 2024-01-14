import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import Styleguide
import SwiftUI
import MembershipFeature

@Reducer
public struct ReceivedLikeGridLogic {
  public init() {}

  public struct State: Equatable {
    let imageUrl: String
    let count: Int
    var receivedCount: String {
      return count > 99 ? "99+" : count.description
    }

    @PresentationState var membership: MembershipLogic.State?

    public init(imageUrl: String, count: Int) {
      self.imageUrl = imageUrl
      self.count = count
    }
  }

  public enum Action {
    case gridButtonTapped
    case membership(PresentationAction<MembershipLogic.Action>)
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .gridButtonTapped:
        state.membership = .init()
        return .none

      case .membership(.presented(.closeButtonTapped)):
        state.membership = nil
        return .none
        
      case .membership:
        return .none
      }
    }
    .ifLet(\.$membership, action: \.membership) {
      MembershipLogic()
    }
  }
}

public struct ReceivedLikeGridView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<ReceivedLikeGridLogic>

  public init(store: StoreOf<ReceivedLikeGridLogic>) {
    self.store = store
  }

  var goldGradient: LinearGradient {
    LinearGradient(
      colors: [
        Color(0xFFE8_B423),
        Color(0xFFF5_D068),
      ],
      startPoint: .leading,
      endPoint: .trailing
    )
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.gridButtonTapped)
      } label: {
        VStack(spacing: 0) {
          CachedAsyncImage(
            url: URL(string: viewStore.imageUrl),
            urlCache: .shared,
            scale: displayScale,
            content: { image in
              image
                .resizable()
                .aspectRatio(3 / 4, contentMode: .fill)
                .blur(radius: 18)
            },
            placeholder: {
              Color.black
                .aspectRatio(3 / 4, contentMode: .fill)
                .overlay {
                  ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(Color.white)
                }
            }
          )
          .cornerRadius(6)
          .overlay {
            RoundedRectangle(cornerRadius: 6)
              .stroke(goldGradient, lineWidth: 3)
          }
          .overlay {
            Text(viewStore.receivedCount)
              .font(.system(.body, weight: .semibold))
              .frame(width: 40, height: 40)
              .foregroundStyle(Color.white)
              .background(goldGradient)
              .clipShape(Circle())
          }
          .overlay(alignment: .bottom) {
            Image(ImageResource.receivedLike)
              .offset(y: 17)
          }

          Text("Liked by \(viewStore.receivedCount) people", bundle: .module)
            .foregroundStyle(Color.primary)
            .font(.system(.subheadline, weight: .semibold))
            .frame(maxWidth: .infinity, minHeight: 54, maxHeight: .infinity, alignment: .leading)
        }
      }
      .fullScreenCover(
        store: store.scope(state: \.$membership, action: \.membership)
      ) { store in
        NavigationStack {
          MembershipView(store: store)
        }
      }
    }
  }
}
