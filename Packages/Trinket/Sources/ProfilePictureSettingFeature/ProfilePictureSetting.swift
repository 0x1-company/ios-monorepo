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

  let store: StoreOf<ProfilePictureSettingLogic>
  private let nextButtonStyle: NextButtonStyle

  public init(
    store: StoreOf<ProfilePictureSettingLogic>,
    nextButtonStyle: NextButtonStyle = .next
  ) {
    self.store = store
    self.nextButtonStyle = nextButtonStyle
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 8) {
        ScrollView {
          VStack(spacing: 36) {
            VStack(spacing: 8) {
              Text("Set your saved Locket.\nto your profile. ", bundle: .module)
                .frame(minHeight: 56)
                .font(.system(.title2, weight: .bold))

              Text("It will be public 🌎", bundle: .module)
                .font(.system(.footnote, weight: .semibold))
                .foregroundStyle(Color.secondary)

              if viewStore.isWarningTextVisible {
                Button {
                  store.send(.howToButtonTapped)
                } label: {
                  HStack(spacing: 2) {
                    Image(systemName: "exclamationmark.triangle.fill")
                      .foregroundStyle(Color.yellow)

                    Text("Select a photo saved with Locket.", bundle: .module)
                      .foregroundStyle(Color.secondary)
                  }
                  .font(.callout)
                }
              }
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
                Array(viewStore.images.enumerated()),
                id: \.offset
              ) { offset, state in
                PhotoGrid(
                  state: state,
                  selection: viewStore.$photoPickerItems,
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
            : String(localized: "Continue", bundle: .module),
          isLoading: viewStore.isActivityIndicatorVisible
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
          Image(ImageResource.beMatch)
        }
      }
      .alert(
        store: store.scope(
          state: \.$destination.alert,
          action: \.destination.alert
        )
      )
      .confirmationDialog(
        store: store.scope(
          state: \.$destination.confirmationDialog,
          action: \.destination.confirmationDialog
        )
      )
    }
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
