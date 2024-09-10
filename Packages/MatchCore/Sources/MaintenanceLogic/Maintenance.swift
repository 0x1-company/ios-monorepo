import ComposableArchitecture
import EnvironmentClient
import SwiftUI

@Reducer
public struct MaintenanceLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let contactUsURL: URL
    public init() {
      @Dependency(\.environment) var environment
      contactUsURL = environment.contactUsURL()
    }
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}
