import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct CategoryEmptyLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
    case emptyButtonTapped
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "CategoryEmpty", of: self)
        return .none

      case .emptyButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }
      }
    }
  }
}

public struct CategoryEmptyView: View {
  let store: StoreOf<CategoryEmptyLogic>

  public init(store: StoreOf<CategoryEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { _ in
      VStack(spacing: 24) {
        Image(ImageResource.empty)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 120)

        Text("Looks like he's gone.", bundle: .module)
          .font(.system(.title3, weight: .semibold))

        PrimaryButton(
          String(localized: "Swipe others", bundle: .module)
        ) {
          store.send(.emptyButtonTapped)
        }
      }
      .padding(.horizontal, 16)
      .multilineTextAlignment(.center)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    CategoryEmptyView(
      store: .init(
        initialState: CategoryEmptyLogic.State(),
        reducer: { CategoryEmptyLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
