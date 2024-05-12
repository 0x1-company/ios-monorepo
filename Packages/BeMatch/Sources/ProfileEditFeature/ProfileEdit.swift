import ComposableArchitecture
import DisplayNameSettingFeature
import GenderSettingFeature
import HowToMovieFeature
import ProfileEditLogic
import ProfilePictureSettingFeature
import ShortCommentSettingFeature
import SwiftUI
import UsernameSettingFeature

public struct ProfileEditView: View {
  let store: StoreOf<ProfileEditLogic>

  public init(store: StoreOf<ProfileEditLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Section {
          Button {
            store.send(.usernameSettingButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Username on BeReal.", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.displayNameSettingButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Name", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.genderSettingButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Gender", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.pictureSettingButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Profile Image", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.shortCommentButtonTapped)
          } label: {
            LabeledContent {
              HStack {
                ShortCommentStatus(status: viewStore.user?.shortComment?.status.value)
                Image(systemName: "chevron.right")
              }
            } label: {
              Text("Short Comment", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("PROFILE", bundle: .module)
        }
      }
      .multilineTextAlignment(.center)
      .navigationTitle(String(localized: "Edit Profile", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "xmark")
              .bold()
              .foregroundStyle(Color.white)
          }
        }
      }
      .sheet(
        store: store.scope(
          state: \.$destination.beRealSample,
          action: \.destination.beRealSample
        )
      ) { store in
        NavigationStack {
          HowToMovieView(store: store)
        }
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination.genderSetting,
          action: \.destination.genderSetting
        )
      ) { store in
        GenderSettingView(store: store, nextButtonStyle: .save, canSkip: false)
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination.usernameSetting,
          action: \.destination.usernameSetting
        )
      ) { store in
        UsernameSettingView(store: store, nextButtonStyle: .save)
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination.pictureSetting,
          action: \.destination.pictureSetting
        )
      ) { store in
        ProfilePictureSettingView(store: store, nextButtonStyle: .save)
      }
      .navigationDestination(
        store: store.scope(
          state: \.$destination.shortComment,
          action: \.destination.shortComment
        ),
        destination: ShortCommentSettingView.init(store:)
      )
      .navigationDestination(
        store: store.scope(
          state: \.$destination.displayNameSetting,
          action: \.destination.displayNameSetting
        ),
        destination: DisplayNameSettingView.init(store:)
      )
    }
  }
}
