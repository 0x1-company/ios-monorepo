import BeMatch
import ComposableArchitecture
import ProfileSharedFeature
import Styleguide
import SwiftUI

@Reducer
public struct ProfileExplorerPreviewContentLogic {
  public init() {}

  public struct State: Equatable {
    let user: BeMatch.ProfileExplorerPreviewQuery.Data.UserByMatched

    @PresentationState var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
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

  public var body: some Reducer<State, Action> {
    Scope(state: \.pictureSlider, action: \.pictureSlider) {
      PictureSliderLogic()
    }
    Reduce<State, Action> { _, action in
      switch action {
      default:
        return .none
      }
    }
    .ifLet(\.$confirmationDialog, action: \.confirmationDialog) {}
  }
}

public struct ProfileExplorerPreviewContentView: View {
  let store: StoreOf<ProfileExplorerPreviewContentLogic>

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
