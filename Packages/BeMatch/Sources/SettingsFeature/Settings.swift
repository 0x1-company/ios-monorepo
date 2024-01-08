import AnalyticsClient
import Constants
import Build
import ComposableArchitecture
import SwiftUI

@Reducer
public struct SettingsLogic {
  public init() {}

  public struct State: Equatable {
    var bundleShortVersion: String
    
    public init() {
      @Dependency(\.build) var build
      self.bundleShortVersion = build.bundleShortVersion()
    }
  }

  public enum Action {
    case onTask
    case onAppear
    case myProfileButtonTapped
    case editProfileButtonTapped
    case howItWorksButtonTapped
    case otherButtonTapped
    case shareButtonTapped
    case rateButtonTapped
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "Settings", of: self)
        return .none
        
      default:
        return .none
      }
    }
  }
}

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
              Label {
                Text("My Profile", bundle: .module)
              } icon: {
                Image(systemName: "person")
              }
              .foregroundStyle(Color.primary)
            }
          }
          
          Button {
            store.send(.editProfileButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Label {
                Text("Edit Profile", bundle: .module)
              } icon: {
                Image(systemName: "square.and.pencil")
              }
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
              Label {
                Text("How It Works", bundle: .module)
              } icon: {
                Image(systemName: "info.circle")
              }
              .foregroundStyle(Color.primary)
            }
          }

          Link(destination: Constants.contactUsURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Label {
                Text("Contact Us", bundle: .module)
              } icon: {
                Image(systemName: "questionmark.circle")
              }
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
              Label {
                Text("Other", bundle: .module)
              } icon: {
                Image(systemName: "hammer.circle")
              }
              .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("Settings", bundle: .module)
        }

        Section {
          Link(destination: Constants.termsOfUseURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Label {
                Text("Terms of Use", bundle: .module)
              } icon: {
                Image(systemName: "signature")
              }
              .foregroundStyle(Color.primary)
            }
          }
          
          Link(destination: Constants.termsOfUseURL) {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Label {
                Text("Privacy Policy", bundle: .module)
              } icon: {
                Image(systemName: "lock")
              }
              .foregroundStyle(Color.primary)
            }
          }
          
          Button {
            store.send(.shareButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Label {
                Text("Share BeMatch.", bundle: .module)
              } icon: {
                Image(systemName: "square.and.arrow.up")
              }
              .foregroundStyle(Color.primary)
            }
          }
          
          Button {
            store.send(.rateButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Label {
                Text("Rate BeMatch.", bundle: .module)
              } icon: {
                Image(systemName: "star")
              }
              .foregroundStyle(Color.primary)
            }
          }
        } header: {
          Text("ABOUT", bundle: .module)
        } footer: {
          Text("Version \(viewStore.bundleShortVersion)", bundle: .module)
            .frame(height: 44)
            .frame(maxWidth: .infinity, alignment: .center)
        }
      }
      .navigationTitle(String(localized: "Settings", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
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
//  .environment(\.locale, Locale(identifier: "ja-JP"))
}
