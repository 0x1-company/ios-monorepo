import ComposableArchitecture
import ConstantsClient
import SwiftUI

@Reducer
public struct MaintenanceLogic {
  public init() {}

  public struct State: Equatable {
    public let contactUsURL: URL
    public init() {
      @Dependency(\.constants) var constants
      contactUsURL = constants.contactUsURL()
    }
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}
