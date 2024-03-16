import AnalyticsClient
import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct CategoryRowLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    let user: BeMatch.SwipeCard
    let isBlur: Bool

    public var id: String {
      return user.id
    }

    public init(user: BeMatch.SwipeCard, isBlur: Bool) {
      self.user = user
      self.isBlur = isBlur
    }
  }

  public enum Action {
    case rowButtonTapped
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .rowButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }
      }
    }
  }
}

public struct CategoryRowView: View {
  @Environment(\.displayScale) var displayScale
  @Perception.Bindable var store: StoreOf<CategoryRowLogic>

  public init(store: StoreOf<CategoryRowLogic>) {
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
    WithPerceptionTracking {
      Button {
        store.send(.rowButtonTapped)
      } label: {
        CachedAsyncImage(
          url: URL(string: store.user.images[0].imageUrl),
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
        .blur(radius: store.isBlur ? 18 : 0)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(alignment: .bottom) {
          if !store.isBlur {
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
        .overlay {
          if store.isBlur {
            RoundedRectangle(cornerRadius: 8)
              .stroke(goldGradient, lineWidth: 3)
          }
        }
        .padding(.vertical, 2)
      }
      .buttonStyle(HoldDownButtonStyle())
    }
  }
}
