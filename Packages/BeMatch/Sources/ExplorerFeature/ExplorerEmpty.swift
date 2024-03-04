import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct ExplorerEmptyLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case emptyButtonTapped
  }
  
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .emptyButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
        }
      }
    }
  }
}

public struct ExplorerEmptyView: View {
  let store: StoreOf<ExplorerEmptyLogic>

  public init(store: StoreOf<ExplorerEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
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
  }
}

#Preview {
  NavigationStack {
    ExplorerEmptyView(
      store: .init(
        initialState: ExplorerEmptyLogic.State(),
        reducer: { ExplorerEmptyLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
