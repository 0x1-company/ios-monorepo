import AnalyticsClient
import ComposableArchitecture
import DirectMessageFeature
import SwiftUI

@Reducer
public struct ProfileExplorerLogic {
  public init() {}

  public enum Tab: Hashable {
    case message
    case profile
  }

  public struct State: Equatable {
    let username: String
    var directMessage: DirectMessageLogic.State
    var preview: ProfileExplorerPreviewLogic.State

    @BindingState var currentTab = Tab.message

    public init(username: String, targetUserId: String) {
      self.username = username
      directMessage = DirectMessageLogic.State(
        targetUserId: targetUserId
      )
      preview = ProfileExplorerPreviewLogic.State(
        targetUserId: targetUserId
      )
    }
  }

  public enum Action: BindableAction {
    case onTask
    case principalButtonTapped
    case reportButtonTapped
    case binding(BindingAction<State>)
    case directMessage(DirectMessageLogic.Action)
    case preview(ProfileExplorerPreviewLogic.Action)
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Scope(state: \.directMessage, action: \.directMessage) {
      DirectMessageLogic()
    }
    Scope(state: \.preview, action: \.preview) {
      ProfileExplorerPreviewLogic()
    }
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .principalButtonTapped:
        state.currentTab = Tab.profile
        return .none

      default:
        return .none
      }
    }
  }
}

public struct ProfileExplorerView: View {
  let store: StoreOf<ProfileExplorerLogic>

  public init(store: StoreOf<ProfileExplorerLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      TabView(selection: viewStore.$currentTab) {
        DirectMessageView(store: store.scope(state: \.directMessage, action: \.directMessage))
          .tag(ProfileExplorerLogic.Tab.message)

        ProfileExplorerPreviewView(store: store.scope(state: \.preview, action: \.preview))
          .tag(ProfileExplorerLogic.Tab.profile)
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar(.hidden, for: .tabBar)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Button {
            store.send(.principalButtonTapped, animation: .default)
          } label: {
            Text(viewStore.username)
              .foregroundStyle(Color.primary)
              .font(.system(.callout, weight: .semibold))
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Button {
              store.send(.reportButtonTapped)
            } label: {
              Label {
                Text("Report", bundle: .module)
              } icon: {
                Image(systemName: "exclamationmark.triangle")
              }
            }
          } label: {
            Image(systemName: "ellipsis")
              .bold()
              .foregroundStyle(Color.white)
              .frame(width: 44, height: 44)
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    ProfileExplorerView(
      store: .init(
        initialState: ProfileExplorerLogic.State(
          username: "tomokisun",
          targetUserId: "id"
        ),
        reducer: { ProfileExplorerLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
