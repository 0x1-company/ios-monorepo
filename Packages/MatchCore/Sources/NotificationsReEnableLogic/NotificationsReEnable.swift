import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI
import UIApplicationClient

@Reducer
public struct NotificationsReEnableLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public init() {}
  }

  public enum Action {
    case onTapGesture
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.application.openNotificationSettingsURLString) var openNotificationSettingsURLString

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTapGesture:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          let openNotificationSettingsURLString = await openNotificationSettingsURLString()
          guard let url = URL(string: openNotificationSettingsURLString) else { return }
          await openURL(url)
        }
      }
    }
  }
}
