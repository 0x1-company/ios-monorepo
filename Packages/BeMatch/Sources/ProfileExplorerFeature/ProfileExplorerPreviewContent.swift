import AnalyticsClient
import AnalyticsKeys
import BeMatch
import ComposableArchitecture
import FeedbackGeneratorClient
import ProfileSharedFeature
import Styleguide
import SwiftUI

@Reducer
public struct ProfileExplorerPreviewContentLogic {
  public init() {}

  @ObservableState
  public struct State {
    let user: BeMatch.ProfileExplorerPreviewQuery.Data.UserByMatched

    @Presents var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    var pictureSlider: PictureSliderLogic.State

    public init(user: BeMatch.ProfileExplorerPreviewQuery.Data.UserByMatched) {
      self.user = user
      pictureSlider = PictureSliderLogic.State(data: user.fragments.pictureSlider)
    }
  }

  public enum Action {
    case addBeRealButtonTapped
    case pictureSlider(PictureSliderLogic.Action)
    case confirmationDialog(PresentationAction<ConfirmationDialog>)

    public enum ConfirmationDialog: Equatable {
      case confirm
    }
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Scope(state: \.pictureSlider, action: \.pictureSlider) {
      PictureSliderLogic()
    }
    Reduce<State, Action> { state, action in
      switch action {
      case .addBeRealButtonTapped:
        let username = state.user.berealUsername
        guard let url = URL(string: "https://bere.al/\(username)")
        else { return .none }

        analytics.buttonClick(name: \.addBeReal, parameters: [
          "url": url.absoluteString,
        ])

        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
        }

      default:
        return .none
      }
    }
    .ifLet(\.$confirmationDialog, action: \.confirmationDialog) {}
  }
}

public struct ProfileExplorerPreviewContentView: View {
  @Perception.Bindable var store: StoreOf<ProfileExplorerPreviewContentLogic>

  public init(store: StoreOf<ProfileExplorerPreviewContentLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      PictureSliderView(store: store.scope(state: \.pictureSlider, action: \.pictureSlider))

      PrimaryButton(
        String(localized: "Add BeReal", bundle: .module)
      ) {
        store.send(.addBeRealButtonTapped)
      }
      .padding(.horizontal, 16)

      Spacer()
    }
    .confirmationDialog(store: store.scope(state: \.$confirmationDialog, action: \.confirmationDialog))
  }
}
