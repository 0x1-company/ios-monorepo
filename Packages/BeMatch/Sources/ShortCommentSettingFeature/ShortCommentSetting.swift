import AnalyticsClient
import Styleguide
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ShortCommentSettingLogic {
  public init() {}

  public struct State: Equatable {
    @BindingState var shortComment: String
    @BindingState var focus: Focus?
    
    var isDisabled = true
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
    case onAppear
    case saveButtonTapped
    case binding(BindingAction<State>)
    case delegate(Delegate)
    
    public enum Delegate: Equatable {
      case nextScreen
    }
  }

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
        return .send(.delegate(.nextScreen))
        
      case .binding:
        state.isDisabled = state.shortComment.isEmpty
        return .none
        
      default:
        return .none
      }
    }
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
          .frame(height: 50)
          .font(.system(.title3, weight: .semibold))
          .multilineTextAlignment(.center)
        
        VStack(spacing: 64) {
          TextEditor(text: viewStore.$shortComment)
            .frame(height: 140)
            .lineLimit(1 ... 3)
            .focused($focus, equals: .shortComment)

          Text("Do not write your BeReal username or other social networking IDs. Your profile will not be visible to others.", bundle: .module)
            .font(.caption)
            .foregroundStyle(Color.secondary)
            .multilineTextAlignment(.center)
        }
        
        Spacer()
        
        PrimaryButton(
          String(localized: "Save", bundle: .module),
          isLoading: viewStore.isActivityIndicatorVisible,
          isDisabled: viewStore.isDisabled
        ) {
          store.send(.saveButtonTapped)
        }
      }
      .padding(.top, 24)
      .padding(.horizontal, 16)
      .padding(.bottom, 16)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
      .bind(viewStore.$focus, to: $focus)
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
