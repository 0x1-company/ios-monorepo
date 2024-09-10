import AnalyticsClient
import API
import APIClient
import ComposableArchitecture

import SwiftUI

@Reducer
public struct InvitationCodeLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public var code = ""

    public init() {}
  }

  public enum Action {
    case onTask
    case shareInvitationCodeButtonTapped
    case invitationCodeResponse(Result<API.InvitationCodeQuery.Data, Error>)
  }

  @Dependency(\.api) var api
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case invitationCode
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "InvitationCode", of: self)
        return .run { send in
          for try await data in api.invitationCode() {
            await send(.invitationCodeResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.invitationCodeResponse(.failure(error)))
        }
        .cancellable(id: Cancel.invitationCode, cancelInFlight: true)

      case .shareInvitationCodeButtonTapped:
        return .none

      case let .invitationCodeResponse(.success(data)):
        state.code = data.invitationCode.code
        return .none

      default:
        return .none
      }
    }
  }
}
