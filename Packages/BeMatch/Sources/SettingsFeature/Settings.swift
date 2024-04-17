import AchievementFeature
import ActivityView
import ComposableArchitecture
import ProfileEditFeature
import ProfileFeature
import SettingsLogic
import SwiftUI
import TutorialFeature

public struct SettingsView: View {
  let store: StoreOf<SettingsLogic>

  public init(store: StoreOf<SettingsLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Section {
          Button {
            store.send(.myProfileButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("My Profile", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.editProfileButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Edit Profile", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

//          Button {
//            store.send(.achievementButtonTapped)
//          } label: {
//            LabeledContent {
//              Image(systemName: "chevron.right")
//            } label: {
//              Text("Achievement", bundle: .module)
//                .foregroundStyle(Color.primary)
//            }
//          }

          Button {
            store.send(.membershipStatusButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Membership Status", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.bematchProButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("BeMatch PRO", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("PROFILE", bundle: .module)
        }

        Section {
          Button {
            store.send(.howItWorksButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("How It Works", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Link(destination: Constants.faqURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("FAQ", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Link(destination: Constants.contactUsURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Contact Us", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

        } header: {
          Text("Help", bundle: .module)
        }

        Section {
          Button {
            store.send(.otherButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Other", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("Settings", bundle: .module)
        }

        Section {
          Link(destination: Constants.instagramURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Instagram", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Link(destination: Constants.tiktokURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("TikTok", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("FOLLOW ME", bundle: .module)
        }

        Section {
          Link(destination: Constants.termsOfUseURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Terms of Use", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Link(destination: Constants.privacyPolicyURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Privacy Policy", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.shareButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Share BeMatch.", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.rateButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Rate BeMatch.", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.versionButtonTapped, animation: .default)
          } label: {
            LabeledContent {
              Text(viewStore.bundleShortVersion)
            } label: {
              Text("Version", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("ABOUT", bundle: .module)
        } footer: {
          IfLetStore(
            store.scope(state: \.creationDate, action: \.creationDate),
            then: CreationDateView.init(store:)
          )
          .padding(.bottom, 24)
          .frame(maxWidth: .infinity, alignment: .center)
          .multilineTextAlignment(.center)
        }
      }
      .navigationTitle(String(localized: "Settings", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .sheet(isPresented: viewStore.$isSharePresented) {
        ActivityView(
          activityItems: [viewStore.shareText],
          applicationActivities: nil
        ) { activityType, result, _, _ in
          store.send(
            .onCompletion(
              SettingsLogic.CompletionWithItems(
                activityType: activityType,
                result: result
              )
            )
          )
        }
        .presentationDetents([.medium, .large])
      }
      .fullScreenCover(
        store: store.scope(state: \.$destination.tutorial, action: \.destination.tutorial),
        content: TutorialView.init(store:)
      )
      .fullScreenCover(
        store: store.scope(state: \.$destination.profile, action: \.destination.profile)
      ) { store in
        NavigationStack {
          ProfileView(store: store)
        }
      }
      .fullScreenCover(
        store: store.scope(state: \.$destination.profileEdit, action: \.destination.profileEdit)
      ) { store in
        NavigationStack {
          ProfileEditView(store: store)
        }
      }
      .fullScreenCover(
        store: store.scope(state: \.$destination.achievement, action: \.destination.achievement)
      ) { store in
        NavigationStack {
          AchievementView(store: store)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    SettingsView(
      store: .init(
        initialState: SettingsLogic.State(),
        reducer: { SettingsLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
