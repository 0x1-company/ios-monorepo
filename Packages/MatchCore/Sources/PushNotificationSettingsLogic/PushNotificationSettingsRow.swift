import API
import ComposableArchitecture

@Reducer
public struct PushNotificationSettingsRowLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public var id: String {
      pushNotificationKind.rawValue
    }

    public var allow: Bool
    public var pushNotificationKind: GraphQLEnum<API.PushNotificationKind>

    public init(
      allow: Bool,
      pushNotificationKind: GraphQLEnum<API.PushNotificationKind>
    ) {
      self.allow = allow
      self.pushNotificationKind = pushNotificationKind
    }
  }

  public enum Action {
    case onTask
    case toggleButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none
      
      case .toggleButtonTapped:
        state.allow.toggle()
        return .none
      }
    }
  }
}
