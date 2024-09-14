import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
import DirectMessageLogic
import FeedbackGeneratorClient
import ReportLogic
import SwiftUI

@Reducer
public struct ProfileExplorerLogic {
  public init() {}

  public enum Tab: Hashable {
    case message
    case profile
  }

  @ObservableState
  public struct State: Equatable {
    public let displayName: String
    public let targetUserId: String

    public var currentTab: Tab
    public var text = ""

    public var directMessage: DirectMessageLogic.State
    public var preview: ProfileExplorerPreviewLogic.State
    @Presents public var destination: Destination.State?

    public var isDisabled: Bool {
      return text.isEmpty
    }

    public init(
      displayName: String,
      targetUserId: String,
      tab: Tab = Tab.message
    ) {
      currentTab = tab
      self.displayName = displayName
      self.targetUserId = targetUserId
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
    case unmatchButtonTapped
    case reportButtonTapped
    case blockButtonTapped
    case sendButtonTapped
    case binding(BindingAction<State>)
    case directMessage(DirectMessageLogic.Action)
    case preview(ProfileExplorerPreviewLogic.Action)
    case destination(PresentationAction<Destination.Action>)
    case createMessageResponse(Result<API.CreateMessageMutation.Data, Error>)
    case deleteMatchResponse(Result<API.DeleteMatchMutation.Data, Error>)
    case delegate(Delegate)
    public enum Delegate: Equatable {
      case unmatch(String)
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.api.deleteMatch) var deleteMatch
  @Dependency(\.dismiss) var dismiss

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
        analytics.logScreen(screenName: "ProfileExplorer", of: self)
        return .none

      case .principalButtonTapped:
        state.currentTab = Tab.profile
        return .none

      case .sendButtonTapped where !state.isDisabled:
        let input = API.CreateMessageInput(
          targetUserId: state.targetUserId,
          text: state.text
        )
        state.text.removeAll()
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.createMessageResponse(Result {
            try await api.createMessage(input)
          }))
        }

      case .unmatchButtonTapped, .blockButtonTapped:
        state.destination = .confirmationDialog(
          ConfirmationDialogState {
            TextState("Unmatch", bundle: .module)
          } actions: {
            ButtonState(role: .destructive, action: .confirm) {
              TextState("Confirm", bundle: .module)
            }
          } message: {
            TextState("Are you sure you want to unmatch?", bundle: .module)
          }
        )
        return .none

      case .reportButtonTapped:
        state.destination = .report(ReportLogic.State(targetUserId: state.targetUserId))
        return .none

      case let .directMessage(.child(.content(.rows(.element(id, .reportButtonTapped))))):
        state.destination = .report(ReportLogic.State(messageId: id))
        return .none

      case .createMessageResponse(.success):
        return DirectMessageLogic()
          .reduce(into: &state.directMessage, action: .onTask)
          .map(Action.directMessage)

      case .deleteMatchResponse:
        let targetUserId = state.targetUserId
        return .run { send in
          await send(.delegate(.unmatch(targetUserId)))
          await dismiss()
        }

      case .destination(.presented(.confirmationDialog(.confirm))):
        state.destination = nil
        let input = API.DeleteMatchInput(targetUserId: state.targetUserId)

        return .run { send in
          await send(.deleteMatchResponse(Result {
            try await deleteMatch(input)
          }))
        }

      case .destination(.dismiss):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case report(ReportLogic)
    case confirmationDialog(ConfirmationDialogState<ConfirmationDialog>)
    
    @CasePathable
    public enum ConfirmationDialog: Equatable {
      case confirm
    }
  }
}
