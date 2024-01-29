import AnalyticsClient
import AnalyticsKeys
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import FirebaseAuthClient
import Styleguide
import SwiftUI

@Reducer
public struct DeleteAccountLogic {
  public init() {}

  public struct State: Equatable {
    @PresentationState var destination: Destination.State?
    @BindingState var otherReason = ""
    var selectedReasons: [String] = []
    let reasons = [
      String(localized: "Safety or privacy conerns", bundle: .module),
      String(localized: "I want to create a new account", bundle: .module),
      String(localized: "I don't use BeMatch anymore", bundle: .module),
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
    case closeUserResponse(Result<BeMatch.CloseUserMutation.Data, Error>)
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
  @Dependency(\.bematch.closeUser) var closeUser
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
        let reason = reasons.joined(separator: ",")

        return .run { send in
          analytics.buttonClick(name: \.delete, parameters: ["reason": reason])
          await send(.closeUserResponse(Result {
            try await closeUser()
         }))
        }

      case .closeUserResponse(.success):
        state.destination = .alert(
          AlertState {
            TextState("Delete Account Completed", bundle: .module)
          } actions: {
            ButtonState(action: .confirmOkay) {
              TextState("OK", bundle: .module)
            }
          }
        )
        return .run { send in
          try? firebaseAuth.signOut()
          await send(.delegate(.accountDeletionCompleted))
        }

      case let .closeUserResponse(.failure(error)):
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

public struct DeleteAccountView: View {
  let store: StoreOf<DeleteAccountLogic>

  public init(store: StoreOf<DeleteAccountLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 8) {
        Text("Are you sure you want to delete your account?", bundle: .module)
          .font(.system(.body, weight: .semibold))

        Text("This **cannot** be undone or recovered.", bundle: .module)

        List {
          ForEach(viewStore.reasons, id: \.self) { reason in
            Button {
              store.send(.reasonButtonTapped(reason))
            } label: {
              LabeledContent {
                if viewStore.selectedReasons.contains(reason) {
                  Image(systemName: "checkmark.circle")
                }
              } label: {
                Text(reason)
                  .foregroundStyle(Color.white)
                  .font(.system(.headline, weight: .semibold))
              }
              .frame(height: 50)
            }
            .id(reason)
          }

          TextField(
            String(localized: "Other Reason", bundle: .module),
            text: viewStore.$otherReason,
            axis: .vertical
          )
          .lineLimit(1 ... 10)
          .frame(minHeight: 54)
          .padding(.horizontal, 16)
          .multilineTextAlignment(.leading)
          .id("other")
        }
        .scrollDisabled(true)

        PrimaryButton(
          String(localized: "Proceed with Deletion", bundle: .module)
        ) {
          store.send(.deleteButtonTapped)
        }
        .padding(.horizontal, 16)

        Button {
          store.send(.notNowButtonTapped)
        } label: {
          Text("Not Now", bundle: .module)
            .frame(height: 50)
            .foregroundStyle(Color.white)
            .font(.system(.subheadline, weight: .semibold))
        }
      }
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Text("Delete Account", bundle: .module)
            .font(.system(.title3, weight: .semibold))
        }
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "xmark")
              .bold()
              .foregroundStyle(Color.white)
          }
          .buttonStyle(HoldDownButtonStyle())
        }
      }
      .alert(
        store: store.scope(state: \.$destination.alert, action: \.destination.alert)
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
    DeleteAccountView(
      store: .init(
        initialState: DeleteAccountLogic.State(),
        reducer: { DeleteAccountLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
