import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct RecommendationLoadingLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}
