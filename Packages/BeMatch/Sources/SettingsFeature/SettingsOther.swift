import AnalyticsClient
import ComposableArchitecture
import DeleteAccountFeature
import SwiftUI

@Reducer
public struct SettingsOtherLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    @PresentationState var deleteAccount: DeleteAccountLogic.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case clearCacheButtonTapped
    case deleteAccountButtonTapped
    case confirmationDialog(PresentationAction<ConfirmationDialog>)
    case deleteAccount(PresentationAction<DeleteAccountLogic.Action>)
    
    public enum ConfirmationDialog {
      case clear
    }
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "SettingsOther", of: self)
        return .none
        
      case .clearCacheButtonTapped:
        state.confirmationDialog = ConfirmationDialogState {
          TextState("Clear cache", bundle: .module)
        } actions: {
          ButtonState(action: .clear) {
            TextState("Clear BeMatch cache", bundle: .module)
          }
        } message: {
          TextState("Clearing cache can help fix some issues", bundle: .module)
        }
        return .none
        
      case .deleteAccountButtonTapped:
        state.deleteAccount = .init()
        return .none
        
      case .confirmationDialog(.presented(.clear)):
        state.confirmationDialog = nil
        return .none
        
      case .deleteAccount(.dismiss):
        state.deleteAccount = nil
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.$confirmationDialog, action: \.confirmationDialog)
    .ifLet(\.$deleteAccount, action: \.deleteAccount) {
      DeleteAccountLogic()
    }
  }
}

public struct SettingsOtherView: View {
  let store: StoreOf<SettingsOtherLogic>

  public init(store: StoreOf<SettingsOtherLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Section {
          Button {
            store.send(.clearCacheButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Label {
                Text("Clear cache", bundle: .module)
              } icon: {
                Image(systemName: "clear")
              }
              .foregroundStyle(Color.primary)
            }
          }
        }
        
        Section {
          Button(role: .destructive) {
            store.send(.deleteAccountButtonTapped)
          } label: {
            Text("Delete Account", bundle: .module)
              .frame(maxWidth: .infinity, alignment: .center)
          }
        }
      }
      .navigationTitle(String(localized: "Other", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
      .confirmationDialog(
        store: store.scope(state: \.$confirmationDialog, action: \.confirmationDialog)
      )
      .fullScreenCover(
        store: store.scope(
          state: \.$deleteAccount,
          action: \.deleteAccount
        )
      ) { store in
        NavigationStack {
          DeleteAccountView(store: store)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    SettingsOtherView(
      store: .init(
        initialState: SettingsOtherLogic.State(),
        reducer: { SettingsOtherLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
