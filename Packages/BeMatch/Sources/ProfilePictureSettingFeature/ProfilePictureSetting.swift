import ComposableArchitecture
import PhotosUI
import ProfilePictureSettingLogic
import Styleguide
import SwiftUI

public struct ProfilePictureSettingView: View {
  public enum NextButtonStyle: Equatable {
    case next
    case save
  }

  @Bindable var store: StoreOf<ProfilePictureSettingLogic>
  private let nextButtonStyle: NextButtonStyle

  public init(
    store: StoreOf<ProfilePictureSettingLogic>,
    nextButtonStyle: NextButtonStyle = .next
  ) {
    self.store = store
    self.nextButtonStyle = nextButtonStyle
  }

  public var body: some View {
    VStack(spacing: 8) {
      ScrollView {
        VStack(spacing: 36) {
          VStack(spacing: 8) {
            Text("Set your photo to your profile (it will be public 🌏)", bundle: .module)
              .frame(minHeight: 50)
              .layoutPriority(1)
              .font(.system(.title3, weight: .semibold))
          }

          LazyVGrid(
            columns: Array(
              repeating: GridItem(spacing: 16),
              count: 3
            ),
            alignment: .center,
            spacing: 16
          ) {
            ForEach(
              Array(store.images.enumerated()),
              id: \.offset
            ) { offset, state in
              PhotoGrid(
                state: state,
                selection: $store.photoPickerItems,
                onDelete: {
                  store.send(.onDelete(offset))
                }
              )
              .id(offset)
            }
          }
        }
        .padding(.top, 24)
      }

      PrimaryButton(
        nextButtonStyle == .save
          ? String(localized: "Save", bundle: .module)
          : String(localized: "Next", bundle: .module),
        isLoading: store.isActivityIndicatorVisible
      ) {
        store.send(.nextButtonTapped)
      }
    }
    .padding(.bottom, 16)
    .padding(.horizontal, 16)
    .multilineTextAlignment(.center)
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .principal) {
        Image(ImageResource.logo)
      }
    }
    .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
    .confirmationDialog(
      $store.scope(state: \.destination?.confirmationDialog, action: \.destination.confirmationDialog)
    )
  }
}

#Preview {
  NavigationStack {
    ProfilePictureSettingView(
      store: .init(
        initialState: ProfilePictureSettingLogic.State(),
        reducer: { ProfilePictureSettingLogic() }
      ),
      nextButtonStyle: .next
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
