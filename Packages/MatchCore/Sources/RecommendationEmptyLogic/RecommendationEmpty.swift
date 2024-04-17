import ActivityView
import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ComposableArchitecture
import ConstantsClient
import Styleguide
import SwiftUI

@Reducer
public struct RecommendationEmptyLogic {
  public init() {}

  public struct CompletionWithItems: Equatable {
    public let activityType: UIActivity.ActivityType?
    public let result: Bool
  }

  public struct State: Equatable {
    var shareURL: URL
    var shareText: String {
      return String(
        localized: "I found an app to increase BeReal's friends, try it.\n\(shareURL.absoluteString)",
        bundle: .module
      )
    }

    @BindingState var isPresented = false
    public init() {
      @Dependency(\.constants) var constants
      shareURL = constants.appStoreForEmptyURL()
    }
  }

  public enum Action: BindableAction {
    case onTask
    case shareButtonTapped
    case currentUserResponse(Result<API.CurrentUserQuery.Data, Error>)
    case onCompletion(CompletionWithItems)
    case binding(BindingAction<State>)
  }

  @Dependency(\.constants) var constants
  @Dependency(\.analytics) var analytics
  @Dependency(\.api.currentUser) var currentUser

  enum Cancel {
    case currentUser
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "RecommendationEmpty", of: self)
        return .run { send in
          for try await data in currentUser() {
            await send(.currentUserResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)))
        }
        .cancellable(id: Cancel.currentUser, cancelInFlight: true)

      case .shareButtonTapped:
        state.isPresented = true
        analytics.buttonClick(name: \.share)
        return .none

      case let .currentUserResponse(.success(data)):
        state.shareURL = data.currentUser.gender == .female
          ? constants.appStoreFemaleForEmptyURL()
          : constants.appStoreForEmptyURL()
        return .none

      case let .onCompletion(completion):
        state.isPresented = false
        analytics.logEvent("activity_completion", [
          "activity_type": completion.activityType?.rawValue,
          "result": completion.result,
        ])
        return .none

      default:
        return .none
      }
    }
  }
}
