import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ComposableArchitecture
import EnvironmentClient
import FeedbackGeneratorClient
import ProfileSharedLogic
import SwiftUI
import UsernameSettingLogic

@Reducer
public struct ProfileLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var currentUser: API.UserInternal?

    public var pictureSlider: PictureSliderLogic.State?
    @Presents public var destination: Destination.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case closeButtonTapped
    case jumpExternalProductButtonTapped
    case editUsernameCloseButtonTapped
    case currentUserResponse(Result<API.CurrentUserQuery.Data, Error>)
    case pictureSlider(PictureSliderLogic.Action)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics
  @Dependency(\.environment) var environment
  @Dependency(\.api.currentUser) var currentUser
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Profile", of: self)
        return .run { send in
          for try await data in currentUser() {
            await send(.currentUserResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)))
        }

      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case .jumpExternalProductButtonTapped:
        switch environment.brand() {
        case .bematch:
          state.destination = .confirmationDialog(.bematch())
        case .picmatch:
          state.destination = .confirmationDialog(.picmatch())
        case .tapmatch:
          state.destination = .confirmationDialog(.tapmatch())
        case .tenmatch:
          state.destination = .confirmationDialog(.tenmatch())
        case .trinket:
          state.destination = .confirmationDialog(.trinket())
        }
        return .none

      case .destination(.presented(.confirmationDialog(.jumpToBeReal))):
        guard
          let externalProductUrl = state.currentUser?.externalProductUrl,
          let url = URL(string: externalProductUrl)
        else { return .none }

        analytics.buttonClick(name: \.addExternalProduct, parameters: [
          "url": url.absoluteString,
        ])

        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
        }

      case .destination(.presented(.confirmationDialog(.editUsername))):
        guard let username = state.currentUser?.berealUsername
        else { return .none }

        state.destination = .editUsername(UsernameSettingLogic.State(username: username))
        return .none

      case .destination(.presented(.editUsername(.delegate(.nextScreen)))):
        state.destination = nil
        return .none

      case .editUsernameCloseButtonTapped:
        state.destination = nil
        return .none

      case let .currentUserResponse(.success(data)):
        let currentUser = data.currentUser.fragments.userInternal
        guard !currentUser.images.isEmpty else {
          return .none
        }
        state.currentUser = currentUser
        state.pictureSlider = .init(data: currentUser.fragments.pictureSlider)
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.pictureSlider, action: \.pictureSlider) {
      PictureSliderLogic()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    @ObservableState
  public enum State: Equatable {
      case editUsername(UsernameSettingLogic.State)
      case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
    }

    public enum Action {
      case editUsername(UsernameSettingLogic.Action)
      case confirmationDialog(ConfirmationDialog)

      public enum ConfirmationDialog: Equatable {
        case jumpToBeReal
        case editUsername
      }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.editUsername, action: \.editUsername, child: UsernameSettingLogic.init)
      Scope(state: \.confirmationDialog, action: \.confirmationDialog, child: EmptyReducer.init)
    }
  }
}

extension ConfirmationDialogState where Action == ProfileLogic.Destination.Action.ConfirmationDialog {
  static func bematch() -> Self {
    Self {
      TextState("Select BeReal", bundle: .module)
    } actions: {
      ButtonState(action: .jumpToBeReal) {
        TextState("Jump to BeReal", bundle: .module)
      }
      ButtonState(action: .editUsername) {
        TextState("Edit username", bundle: .module)
      }
    }
  }

  static func picmatch() -> Self {
    Self {
      TextState("Select Instagram", bundle: .module)
    } actions: {
      ButtonState(action: .jumpToBeReal) {
        TextState("Jump to Instagram", bundle: .module)
      }
      ButtonState(action: .editUsername) {
        TextState("Edit username", bundle: .module)
      }
    }
  }

  static func trinket() -> Self {
    Self {
      TextState("Select Locket", bundle: .module)
    } actions: {
      ButtonState(action: .jumpToBeReal) {
        TextState("Jump to Locket", bundle: .module)
      }
      ButtonState(action: .editUsername) {
        TextState("Edit locket link", bundle: .module)
      }
    }
  }

  static func tapmatch() -> Self {
    Self {
      TextState("Select TapNow", bundle: .module)
    } actions: {
      ButtonState(action: .jumpToBeReal) {
        TextState("Jump to TapNow", bundle: .module)
      }
      ButtonState(action: .editUsername) {
        TextState("Edit username", bundle: .module)
      }
    }
  }

  static func tenmatch() -> Self {
    Self {
      TextState("Select tenten", bundle: .module)
    } actions: {
      ButtonState(action: .jumpToBeReal) {
        TextState("Jump to tenten", bundle: .module)
      }
      ButtonState(action: .editUsername) {
        TextState("Edit PIN", bundle: .module)
      }
    }
  }
}
