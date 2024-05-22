import AnalyticsClient
import ComposableArchitecture
import DeleteAccountLogic
import SwiftUI

@Reducer
public struct SettingsOtherLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState public var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    @PresentationState public var deleteAccount: DeleteAccountLogic.State?
    public init() {}
  }

  public enum Action {
    case onTask
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
        analytics.logScreen(screenName: "SettingsOther", of: self)
        return .none

      case .clearCacheButtonTapped:
        state.confirmationDialog = ConfirmationDialogState {
          TextState("Clear cache", bundle: .module)
        } actions: {
          ButtonState(action: .clear) {
            TextState("Clear TapMatch cache", bundle: .module)
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
