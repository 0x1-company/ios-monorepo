import ComposableArchitecture

@Reducer
public struct InvitationCodeCampaignLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let code: String

    public init(code: String) {
      self.code = code
    }
  }

  public enum Action {
    case invitationCodeButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case sendInvitationCode
    }
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .invitationCodeButtonTapped:
        return .send(.delegate(.sendInvitationCode))
      default:
        return .none
      }
    }
  }
}
