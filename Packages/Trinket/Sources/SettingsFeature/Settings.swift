import AchievementFeature
import ActivityView
import ComposableArchitecture
import MembershipStatusFeature
import ProfileEditFeature
import ProfileFeature
import PushNotificationSettingsFeature
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

          Link(destination: viewStore.faqURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("FAQ", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Link(destination: viewStore.contactUsURL) {
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
            store.send(.pushNotificationSettingsButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Push Notifications", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

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
          Link(destination: viewStore.termsOfUseURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Terms of Use", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Link(destination: viewStore.privacyPolicyURL) {
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
              Text("Share Trinket", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }

          Button {
            store.send(.rateButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Rate Trinket", bundle: .module)
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
      .navigationDestination(
        store: store.scope(state: \.$destination.membershipStatus, action: \.destination.membershipStatus),
        destination: MembershipStatusView.init(store:)
      )
      .navigationDestination(
        store: store.scope(state: \.$destination.other, action: \.destination.other),
        destination: SettingsOtherView.init(store:)
      )
      .navigationDestination(
        store: store.scope(state: \.$destination.pushNotificationSettings, action: \.destination.pushNotificationSettings),
        destination: PushNotificationSettingsView.init(store:)
      )
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
