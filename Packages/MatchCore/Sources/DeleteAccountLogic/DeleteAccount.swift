import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ApolloConcurrency
import ComposableArchitecture
import FeedbackGeneratorClient
import FirebaseAuthClient

import SwiftUI

@Reducer
public struct DeleteAccountLogic {
  public init() {}

  public struct State: Equatable {
    public var isActivityIndicatorVisible = false
    @PresentationState public var destination: Destination.State?
    @BindingState public var otherReason = ""
    public var selectedReasons: [String] = []
    public let reasons = [
      String(localized: "Safety or privacy concerns", bundle: .module),
      String(localized: "I want to create a new account", bundle: .module),
      String(localized: "I don't know how to use it", bundle: .module),
    ]
    public init() {}
  }

  public enum Action: BindableAction {
    case onTask
    case closeButtonTapped
    case reasonButtonTapped(String)
    case deleteButtonTapped
    case notNowButtonTapped
    case closeUserResponse(Result<API.CloseUserMutation.Data, Error>)
    case signOutFailure(Error)
    case binding(BindingAction<State>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case accountDeletionCompleted
    }
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics
  @Dependency(\.firebaseAuth) var firebaseAuth
  @Dependency(\.api.closeUser) var closeUser
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DeleteAccount", of: self)
        return .none

      case .closeButtonTapped:
        analytics.buttonClick(name: \.close)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case .notNowButtonTapped:
        analytics.buttonClick(name: \.notNow)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case let .reasonButtonTapped(reason):
        if state.selectedReasons.contains(reason) {
          state.selectedReasons = state.selectedReasons.filter { $0 != reason }
        } else {
          state.selectedReasons.append(reason)
        }
        return .none

      case .deleteButtonTapped:
        state.destination = .confirmationDialog(
          ConfirmationDialogState {
            TextState("Delete Account", bundle: .module)
          } actions: {
            ButtonState(role: .destructive, action: .confirm) {
              TextState("Confirm", bundle: .module)
            }
          } message: {
            TextState("Are you sure you want to delete your account?", bundle: .module)
          }
        )
        return .none

      case .destination(.presented(.confirmationDialog(.confirm))):
        let reasons = state.selectedReasons + [state.otherReason].filter { !$0.isEmpty }
        let reason = reasons.sorted().joined(separator: ",")

        analytics.buttonClick(name: \.delete, parameters: ["reason": reason])
        state.isActivityIndicatorVisible = true

        return .run { send in
          await send(.closeUserResponse(Result {
            try await closeUser()
          }))
        }

      case .closeUserResponse(.success):
        return .run { send in
          try firebaseAuth.signOut()
          await send(.delegate(.accountDeletionCompleted), animation: .default)
        } catch: { error, send in
          await send(.signOutFailure(error))
        }

      case let .closeUserResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.destination = .alert(
          AlertState {
            TextState("Account deletion failed.", bundle: .module)
          } actions: {
            ButtonState(action: .confirmOkay) {
              TextState("OK", bundle: .module)
            }
          } message: {
            TextState(error.message)
          }
        )
        return .none

      case .closeUserResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case let .signOutFailure(error):
        state.isActivityIndicatorVisible = false
        state.destination = .alert(
          AlertState {
            TextState("Account deletion failed.", bundle: .module)
          } actions: {
            ButtonState(action: .confirmOkay) {
              TextState("OK", bundle: .module)
            }
          } message: {
            TextState(error.localizedDescription)
          }
        )
        return .none

      case .destination(.presented(.alert(.confirmOkay))):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case alert(AlertState<Action.Alert>)
      case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
    }

    public enum Action {
      case alert(Alert)
      case confirmationDialog(ConfirmationDialog)

      public enum ConfirmationDialog: Equatable {
        case confirm
      }

      public enum Alert: Equatable {
        case confirmOkay
      }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.alert, action: \.alert) {}
      Scope(state: \.confirmationDialog, action: \.confirmationDialog) {}
    }
  }
}
