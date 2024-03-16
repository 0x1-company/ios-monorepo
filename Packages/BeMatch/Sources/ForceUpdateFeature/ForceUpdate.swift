import AnalyticsClient
import AnalyticsKeys
import ComposableArchitecture
import Constants
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct ForceUpdateLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTask
    case updateButtonTapped
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ForceUpdate", of: self)
        return .none

      case .updateButtonTapped:
        analytics.buttonClick(name: \.forceUpdate)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(Constants.appStoreURL)
        }
      }
    }
  }
}

public struct ForceUpdateView: View {
  @Perception.Bindable var store: StoreOf<ForceUpdateLogic>

  public init(store: StoreOf<ForceUpdateLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 24) {
        Text("Notice", bundle: .module)
          .font(.system(.title, weight: .semibold))

        Text("... Oh? ! ! Looks like BeMatch...! \nPlease update to the latest version.", bundle: .module)
          .font(.system(.body, weight: .semibold))

        PrimaryButton(
          String(localized: "Update", bundle: .module)
        ) {
          store.send(.updateButtonTapped)
        }
      }
      .padding(.horizontal, 24)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.black)
      .foregroundStyle(Color.white)
      .multilineTextAlignment(.center)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  ForceUpdateView(
    store: .init(
      initialState: ForceUpdateLogic.State(),
      reducer: { ForceUpdateLogic() }
    )
  )
}
