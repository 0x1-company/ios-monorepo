import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ComposableArchitecture
import FeedbackGeneratorClient
import ProfileSharedLogic
import ReportLogic

import SwiftUI

@Reducer
public struct ProfileExternalLogic {
  public init() {}

  public struct State: Equatable {
    public let match: API.MatchGrid
    @BindingState public var selection: API.MatchGrid.TargetUser.Image
    @PresentationState public var destination: Destination.State?

    public var pictureSlider: PictureSliderLogic.State?

    public var createdAt: Date {
      guard let timeInterval = TimeInterval(match.createdAt)
      else { return .now }
      return Date(timeIntervalSince1970: timeInterval / 1000.0)
    }

    public init(match: API.MatchGrid) {
      self.match = match
      selection = match.targetUser.images.first!
      pictureSlider = PictureSliderLogic.State(data: match.targetUser.fragments.pictureSlider)
    }
  }

  public enum Action {
    case onTask
    case onAppear
    case closeButtonTapped
    case unmatchButtonTapped
    case reportButtonTapped
    case addBeRealButtonTapped
    case deleteMatchResponse(Result<API.DeleteMatchMutation.Data, Error>)
    case readMatchResponse(Result<API.ReadMatchMutation.Data, Error>)
    case destination(PresentationAction<Destination.Action>)
    case pictureSlider(PictureSliderLogic.Action)
    case delegate(Delegate)

    public enum ConfirmationDialog: Equatable {
      case confirm
    }

    public enum Delegate: Equatable {
      case unmatch(String)
    }
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics
  @Dependency(\.api.readMatch) var readMatch
  @Dependency(\.api.deleteMatch) var deleteMatch
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ProfileExternal", of: self)

        let matchId = state.match.id
        return .run { send in
          await readMatchRequest(matchId: matchId, send: send)
        }

      case .unmatchButtonTapped:
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
        state.destination = .report(ReportLogic.State(
          targetUserId: state.match.targetUser.id
        ))
        return .none

      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case .addBeRealButtonTapped:
        let externalProductUrl = state.match.targetUser.externalProductUrl
        guard let url = URL(string: externalProductUrl)
        else { return .none }

        analytics.buttonClick(name: \.addBeReal, parameters: [
          "url": url.absoluteString,
          "match_id": state.match.id,
        ])

        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
        }

      case .deleteMatchResponse:
        let matchId = state.match.id
        return .run { send in
          await send(.delegate(.unmatch(matchId)))
          await dismiss()
        }

      case .destination(.presented(.confirmationDialog(.confirm))):
        state.destination = nil
        let targetUserId = state.match.targetUser.id
        let input = API.DeleteMatchInput(targetUserId: targetUserId)

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
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
    .ifLet(\.pictureSlider, action: \.pictureSlider) {
      PictureSliderLogic()
    }
  }

  func readMatchRequest(matchId: String, send: Send<Action>) async {
    await send(.readMatchResponse(Result {
      try await readMatch(matchId)
    }))
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case report(ReportLogic.State)
      case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
    }

    public enum Action {
      case report(ReportLogic.Action)

      case confirmationDialog(ConfirmationDialog)

      public enum ConfirmationDialog: Equatable {
        case confirm
      }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.report, action: \.report, child: ReportLogic.init)
      Scope(state: \.confirmationDialog, action: \.confirmationDialog) {}
    }
  }
}
