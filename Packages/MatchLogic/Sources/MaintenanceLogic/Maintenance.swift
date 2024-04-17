import ComposableArchitecture
import Constants
import Styleguide
import SwiftUI

@Reducer
public struct MaintenanceLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}
