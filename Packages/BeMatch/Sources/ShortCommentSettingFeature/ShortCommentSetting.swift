import AnalyticsClient
import ApolloConcurrency
import BeMatch
import BeMatchClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct ShortCommentSettingLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var shortComment: String
    var focus: Focus?
    @Presents var alert: AlertState<Action.Alert>?

    var isActivityIndicatorVisible = false

    public init(shortComment: String?) {
      self.shortComment = shortComment ?? ""
    }

    enum Focus: Hashable {
      case shortComment
    }
  }

  public enum Action: BindableAction {
    case onTask
    case saveButtonTapped
    case updateShortCommentResponse(Result<BeMatch.UpdateShortCommentMutation.Data, Error>)
    case binding(BindingAction<State>)
    case alert(PresentationAction<Alert>)
    case delegate(Delegate)

    public enum Alert: Equatable {
      case confirmOkay
    }

    public enum Delegate: Equatable {
      case nextScreen
    }
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        state.focus = .shortComment
        analytics.logScreen(screenName: "ShortCommentSetting", of: self)
        return .none

      case .saveButtonTapped:
        state.focus = nil
        state.isActivityIndicatorVisible = true
        let input = BeMatch.UpdateShortCommentInput(
          body: state.shortComment
        )
        return .run { send in
          await send(.updateShortCommentResponse(Result {
            try await bematch.updateShortComment(input)
          }))
        }

      case .updateShortCommentResponse(.success):
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.nextScreen))

      case let .updateShortCommentResponse(.failure(error as ServerError)):
        state.isActivityIndicatorVisible = false
        state.alert = AlertState {
          TextState("Failed to save short comment.", bundle: .module)
        } actions: {
          ButtonState(action: .confirmOkay) {
            TextState("OK", bundle: .module)
          }
        } message: {
          TextState(error.message)
        }
        return .none

      case .updateShortCommentResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .alert(.presented(.confirmOkay)):
        state.alert = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$alert, action: \.alert)
  }
}

public struct ShortCommentSettingView: View {
  @FocusState var focus: ShortCommentSettingLogic.State.Focus?
  @Perception.Bindable var store: StoreOf<ShortCommentSettingLogic>

  public init(store: StoreOf<ShortCommentSettingLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 24) {
        Text("Do not write vour BeReal or other social media username.Your profile will not be visible to others.", bundle: .module)
          .font(.subheadline)
          .foregroundStyle(Color.secondary)

        TextEditor(text: $store.shortComment)
          .frame(height: 100)
          .lineLimit(1 ... 3)
          .focused($focus, equals: .shortComment)
          .padding()
          .overlay(
            RoundedRectangle(cornerRadius: 12)
              .stroke(Color.primary, lineWidth: 1.0)
          )

        PrimaryButton(
          String(localized: "Save", bundle: .module),
          isLoading: store.isActivityIndicatorVisible,
          isDisabled: store.isActivityIndicatorVisible
        ) {
          store.send(.saveButtonTapped)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
      }
      .padding(.top, 24)
      .padding(.horizontal, 16)
      .padding(.bottom, 16)
      .navigationTitle(String(localized: "Comment", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .bind($store.focus, to: $focus)
      .alert($store.scope(state: \.alert, action: \.alert))
    }
  }
}

#Preview {
  NavigationStack {
    ShortCommentSettingView(
      store: .init(
        initialState: ShortCommentSettingLogic.State(
          shortComment: nil
        ),
        reducer: { ShortCommentSettingLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
