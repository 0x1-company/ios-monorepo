import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct MatchEmptyLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case swipeButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case toRecommendation
    }
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .swipeButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.toRecommendation))
        }

      default:
        return .none
      }
    }
  }
}

public struct MatchEmptyView: View {
  @Perception.Bindable var store: StoreOf<MatchEmptyLogic>

  public init(store: StoreOf<MatchEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      Image(ImageResource.matchEmpty)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 240)
        .clipped()

      VStack(spacing: 16) {
        Text("Let's swipe.", bundle: .module)
          .font(.system(.largeTitle, weight: .bold))

        Text("When you match with someone, their profile will appear here", bundle: .module)
          .font(.system(.callout, weight: .semibold))

        PrimaryButton(
          String(localized: "Swipe", bundle: .module)
        ) {
          store.send(.swipeButtonTapped)
        }
      }
    }
    .padding(.top, 20)
    .multilineTextAlignment(.center)
    .foregroundStyle(Color.white)
  }
}

#Preview {
  MatchEmptyView(
    store: .init(
      initialState: MatchEmptyLogic.State(),
      reducer: { MatchEmptyLogic() }
    )
  )
}
