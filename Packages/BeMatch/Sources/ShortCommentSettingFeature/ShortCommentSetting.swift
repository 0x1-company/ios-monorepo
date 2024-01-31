import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct ShortCommentSettingLogic {
  public init() {}

  public struct State: Equatable {
    @BindingState var shortComment: String
    @BindingState var focus: Focus?
    @PresentationState var alert: AlertState<Action.Alert>?

    var isDisabled: Bool
    var isActivityIndicatorVisible = false

    public init(shortComment: String?) {
      let shortComment = shortComment ?? ""
      self.shortComment = shortComment
      self.isDisabled = shortComment.isEmpty
    }

    enum Focus: Hashable {
      case shortComment
    }
  }

  public enum Action: BindableAction {
    case onTask
    case onAppear
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
        return .none

      case .onAppear:
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

      case let .updateShortCommentResponse(.failure(error)):
        state.isActivityIndicatorVisible = false
        state.alert = AlertState {
          TextState("Failed to save short comment.", bundle: .module)
        } actions: {
          ButtonState(action: .confirmOkay) {
            TextState("OK", bundle: .module)
          }
        } message: {
          TextState(error.localizedDescription)
        }
        return .none

      case .binding:
        state.isDisabled = state.shortComment.isEmpty
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
  let store: StoreOf<ShortCommentSettingLogic>

  public init(store: StoreOf<ShortCommentSettingLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 32) {
        Text("Write a short comment.\nLet's appeal!", bundle: .module)
          .frame(minHeight: 50)
          .font(.system(.title3, weight: .semibold))
          .multilineTextAlignment(.center)

        VStack(spacing: 8) {
          TextEditor(text: viewStore.$shortComment)
            .frame(height: 100)
            .lineLimit(1 ... 3)
            .focused($focus, equals: .shortComment)
            .padding()
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary, lineWidth: 1.0)
            )

          Text("Do not write your BeReal username or other social networking IDs. Your profile will not be visible to others.", bundle: .module)
            .font(.caption)
            .frame(minHeight: 50)
            .foregroundStyle(Color.secondary)
        }

        VStack(spacing: 0) {
          Spacer()

          PrimaryButton(
            String(localized: "Save", bundle: .module),
            isLoading: viewStore.isActivityIndicatorVisible,
            isDisabled: viewStore.isDisabled
          ) {
            store.send(.saveButtonTapped)
          }
        }
      }
      .padding(.top, 24)
      .padding(.horizontal, 16)
      .padding(.bottom, 16)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
      .bind(viewStore.$focus, to: $focus)
      .alert(store: store.scope(state: \.$alert, action: \.alert))
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
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
