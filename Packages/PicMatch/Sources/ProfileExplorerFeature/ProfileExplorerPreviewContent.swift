import ComposableArchitecture
import ProfileExplorerLogic
import ProfileSharedFeature
import Styleguide
import SwiftUI

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
        store.send(.addExternalProductButtonTapped)
      }
      .padding(.horizontal, 16)

      Spacer()
    }
    .confirmationDialog(store: store.scope(state: \.$confirmationDialog, action: \.confirmationDialog))
  }
}
