import AnalyticsClient
import Styleguide
import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import SwiftUI

@Reducer
public struct CategoryRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    let user: BeMatch.SwipeCard

    public var id: String {
      return user.id
    }

    public init(user: BeMatch.SwipeCard) {
      self.user = user
    }
  }

  public enum Action {
    case rowButtonTapped
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .rowButtonTapped:
        return .none
      }
    }
  }
}

public struct CategoryRowView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<CategoryRowLogic>

  public init(store: StoreOf<CategoryRowLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.rowButtonTapped)
      } label: {
        CachedAsyncImage(
          url: URL(string: viewStore.user.images[0].imageUrl),
          urlCache: URLCache.shared,
          scale: displayScale
        ) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 200)
        } placeholder: {
          Color.black
            .frame(width: 150, height: 200)
            .overlay {
              ProgressView()
                .tint(Color.white)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(alignment: .bottom) {
          LinearGradient(
            colors: [
              Color.black.opacity(0.0),
              Color.black.opacity(1.0),
            ],
            startPoint: .top,
            endPoint: .bottom
          )
          .frame(height: 100)
          .clipShape(RoundedRectangle(cornerRadius: 8))
        }
      }
      .buttonStyle(HoldDownButtonStyle())
    }
  }
}
