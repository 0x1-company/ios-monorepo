import ComposableArchitecture
import UIKit

@Reducer
public struct SceneDelegateLogic {
  @ObservableState
  public struct State {}
  public enum Action {
    case shortcutItem(UIApplicationShortcutItem)
  }

  public func reduce(into state: inout State, action: Action) -> Effect<Action> {
    .none
  }
}
