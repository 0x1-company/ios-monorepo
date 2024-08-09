import AnalyticsClient
import AnalyticsKeys
import API
import APIClient
import ComposableArchitecture
import EnvironmentClient
import FeedbackGeneratorClient
import StoreKit
import SwiftUI

@Reducer
public struct MatchedLogic {
  public init() {}

  public struct State: Equatable {
    let targetUserId: String
    let tentenPinCode: String
    let externalProductURL: URL
    let brand: EnvironmentClient.Brand

    public var currentUserImageUrl: URL?
    public var targetUserImageUrl: URL?

    public let targetUserDisplayName: String
    public var displayTargetUserInfo: String {
      switch brand {
      case .bematch, .picmatch, .tapmatch, .trinket:
        return externalProductURL.absoluteString
      case .tenmatch:
        return tentenPinCode
      }
    }

    @PresentationState public var destination: Destination.State?

    public init(
      targetUserId: String,
      displayName: String?,
      tentenPinCode: String,
      externalProductURL: URL
    ) {
      @Dependency(\.environment) var environment
      brand = environment.brand()
      self.targetUserId = targetUserId
      self.tentenPinCode = tentenPinCode
      self.externalProductURL = externalProductURL
      targetUserDisplayName = displayName ?? ""
    }
  }

  public enum Action {
    case onTask
    case addExternalProductButtonTapped
    case closeButtonTapped
    case matchedResponse(Result<API.MatchedQuery.Data, Error>)
    case destination(PresentationAction<Destination.Action>)
  }

  @Dependency(\.api) var api
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.environment) var environment
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Matched", of: self)
        return .run { [id = state.targetUserId] send in
          for try await data in api.matched(id) {
            await send(.matchedResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.matchedResponse(.failure(error)))
        }

      case .addExternalProductButtonTapped:
        switch environment.brand() {
        case .bematch, .picmatch, .tapmatch, .trinket:
          analytics.buttonClick(name: \.addExternalProduct, parameters: [
            "url": state.externalProductURL.absoluteString,
          ])

          return .run { [url = state.externalProductURL] _ in
            await feedbackGenerator.impactOccurred()
            await openURL(url)
            await dismiss()
          }
        case .tenmatch:
          analytics.buttonClick(name: \.addExternalProduct, parameters: [
            "url": state.tentenPinCode,
          ])

          state.destination = .alert(
            AlertState {
              TextState("Copied tenten’s PIN", bundle: .module)
            } actions: {
              ButtonState(action: .confirmOkay) {
                TextState("OK", bundle: .module)
              }
            }
          )
          return .none
        }

      case .closeButtonTapped:
        return .run { _ in
          await dismiss()
        }

      case .destination(.presented(.alert(.confirmOkay))):
        state.destination = nil
        return .run { _ in
          await dismiss()
        }

      case let .matchedResponse(.success(data)):
        let currentUserImages = data.currentUser.images.sorted(by: { $0.order > $1.order })
        let targetUserImages = data.userByMatched.images.sorted(by: { $0.order > $1.order })

        guard
          let currentUserImage = currentUserImages.first,
          let targetUserImage = targetUserImages.first
        else { return .none }

        state.currentUserImageUrl = URL(string: currentUserImage.imageUrl)
        state.targetUserImageUrl = URL(string: targetUserImage.imageUrl)
        return .none

      case .matchedResponse(.failure):
        return .run { _ in
          await dismiss()
        }

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
    }

    public enum Action {
      case alert(Alert)

      public enum Alert: Equatable {
        case confirmOkay
      }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.alert, action: \.alert) {}
    }
  }
}
