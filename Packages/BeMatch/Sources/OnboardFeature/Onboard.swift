import BeMatch
import BeMatchClient
import BeRealCaptureFeature
import BeRealSampleFeature
import ComposableArchitecture
import FirebaseAuth
import GenderSettingFeature
import InvitationFeature
import SwiftUI
import UserDefaultsClient
import UsernameSettingFeature

@Reducer
public struct OnboardLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    let user: BeMatch.UserInternal?
    var username: UsernameSettingLogic.State
    var path = StackState<Path.State>()
    var hasInvitationCampaign = false
    @Presents var destination: Destination.State?

    public init(user: BeMatch.UserInternal?) {
      self.user = user
      username = UsernameSettingLogic.State(username: user?.berealUsername ?? "")
    }
  }

  public enum Action {
    case onTask
    case activeInvitationCampaign(Result<BeMatch.ActiveInvitationCampaignQuery.Data, Error>)
    case username(UsernameSettingLogic.Action)
    case path(StackAction<Path.State, Path.Action>)
    case destination(PresentationAction<Destination.Action>)
    case delegate(Delegate)

    public enum Delegate {
      case finish
    }
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.userDefaults) var userDefaults

  enum Cancel {
    case activeInvitationCampaign
  }

  public var body: some Reducer<State, Action> {
    Scope(state: \.username, action: \.username) {
      UsernameSettingLogic()
    }
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          for try await data in bematch.activeInvitationCampaign() {
            await send(.activeInvitationCampaign(.success(data)))
          }
        } catch: { error, send in
          await send(.activeInvitationCampaign(.failure(error)))
        }
        .cancellable(id: Cancel.activeInvitationCampaign, cancelInFlight: true)

      case let .activeInvitationCampaign(.success(data)):
        state.hasInvitationCampaign = data.activeInvitationCampaign != nil
        return .none

      case .username(.delegate(.nextScreen)):
        let gender = state.user?.gender.value
        state.path.append(.gender(GenderSettingLogic.State(gender: gender == .other ? nil : gender)))
        return .none

      case .path(.element(_, .gender(.delegate(.nextScreen)))):
        state.path.append(.sample())
        return .none

      case .path(.element(_, .sample(.delegate(.nextScreen)))):
        state.path.append(.capture())
        return .none

      case .path(.element(_, .capture(.delegate(.howTo)))):
        state.destination = .sample()
        return .none

      case .path(.element(_, .capture(.delegate(.nextScreen)))):
        if state.hasInvitationCampaign {
          state.path.append(.invitation())
          return .none
        }
        return .send(.delegate(.finish))

      case .path(.element(_, .invitation(.delegate(.nextScreen)))):
        return .send(.delegate(.finish))

      case .destination(.presented(.sample(.delegate(.nextScreen)))):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Path {
    public enum State: Equatable {
      case gender(GenderSettingLogic.State)
      case sample(BeRealSampleLogic.State = .init())
      case capture(BeRealCaptureLogic.State = .init())
      case invitation(InvitationLogic.State = .init())
    }

    public enum Action {
      case gender(GenderSettingLogic.Action)
      case sample(BeRealSampleLogic.Action)
      case capture(BeRealCaptureLogic.Action)
      case invitation(InvitationLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.gender, action: \.gender, child: GenderSettingLogic.init)
      Scope(state: \.sample, action: \.sample, child: BeRealSampleLogic.init)
      Scope(state: \.capture, action: \.capture, child: BeRealCaptureLogic.init)
      Scope(state: \.invitation, action: \.invitation, child: InvitationLogic.init)
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case sample(BeRealSampleLogic.State = .init())
    }

    public enum Action {
      case sample(BeRealSampleLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.sample, action: \.sample, child: BeRealSampleLogic.init)
    }
  }
}

public struct OnboardView: View {
  @Perception.Bindable var store: StoreOf<OnboardLogic>

  public init(store: StoreOf<OnboardLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStackStore(store.scope(state: \.path, action: \.path)) {
      UsernameSettingView(
        store: store.scope(state: \.username, action: \.username),
        nextButtonStyle: .next
      )
    } destination: { store in
      switch store {
      case .gender:
        CaseLet(
          /OnboardLogic.Path.State.gender,
          action: OnboardLogic.Path.Action.gender,
          then: { store in
            GenderSettingView(store: store, nextButtonStyle: .next, canSkip: true)
          }
        )
      case .sample:
        CaseLet(
          /OnboardLogic.Path.State.sample,
          action: OnboardLogic.Path.Action.sample,
          then: BeRealSampleView.init(store:)
        )
      case .capture:
        CaseLet(
          /OnboardLogic.Path.State.capture,
          action: OnboardLogic.Path.Action.capture,
          then: { store in
            BeRealCaptureView(store: store, nextButtonStyle: .next)
          }
        )
      case .invitation:
        CaseLet(
          /OnboardLogic.Path.State.invitation,
          action: OnboardLogic.Path.Action.invitation,
          then: InvitationView.init(store:)
        )
      }
    }
    .tint(Color.white)
    .task { await store.send(.onTask).finish() }
    .sheet(
      item: $store.scope(state: \.destination?.sample, action: \.destination.sample)
    ) { store in
      NavigationStack {
        BeRealSampleView(store: store)
      }
    }
  }
}
