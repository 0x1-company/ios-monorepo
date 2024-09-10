import API
import ComposableArchitecture

@Reducer
public struct PushNotificationSettingsRowLogic {
  public init() {}

  @ObservableState
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

  public enum Action: BindableAction {
    case binding(BindingAction<State>)
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
  }
}
