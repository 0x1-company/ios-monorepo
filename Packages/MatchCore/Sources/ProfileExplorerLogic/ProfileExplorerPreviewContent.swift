import AnalyticsClient
import AnalyticsKeys
import API
import ComposableArchitecture
import FeedbackGeneratorClient
import ProfileSharedLogic

import SwiftUI

@Reducer
public struct ProfileExplorerPreviewContentLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let user: API.ProfileExplorerPreviewQuery.Data.UserByMatched

    @Presents public var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    public var pictureSlider: PictureSliderLogic.State

    public init(user: API.ProfileExplorerPreviewQuery.Data.UserByMatched) {
      self.user = user
      pictureSlider = PictureSliderLogic.State(data: user.fragments.pictureSlider)
    }
  }

  public enum Action {
    case addExternalProductButtonTapped
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
      case .addExternalProductButtonTapped:
        let externalProductUrl = state.user.externalProductUrl
        guard let url = URL(string: externalProductUrl)
        else { return .none }

        analytics.buttonClick(name: \.addExternalProduct, parameters: [
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
