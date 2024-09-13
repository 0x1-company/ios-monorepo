import ComposableArchitecture
import ProfileExplorerLogic
import ProfileSharedFeature
import Styleguide
import SwiftUI

public struct ProfileExplorerPreviewContentView: View {
  @Bindable var store: StoreOf<ProfileExplorerPreviewContentLogic>

  public init(store: StoreOf<ProfileExplorerPreviewContentLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      PictureSliderView(store: store.scope(state: \.pictureSlider, action: \.pictureSlider))

      Spacer()
    }
    .confirmationDialog($store.scope(state: \.confirmationDialog, action: \.confirmationDialog))
  }
}
