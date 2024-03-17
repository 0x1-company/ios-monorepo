import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct InvitationLogic {
  public init() {}

  public struct State: Equatable {
    var isDisabled = true
    var isActivityIndicatorVisible = false
    @BindingState var code = String()

    public init() {}
  }

  public enum Action: BindableAction {
    case onTask
    case nextButtonTapped
    case skipButtonTapped
    case createInvitationResponse(Result<BeMatch.CreateInvitationMutation.Data, Error>)
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case nextScreen
    }
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case createInvitation
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Invitation", of: self)
        return .none

      case .nextButtonTapped:
        state.isActivityIndicatorVisible = true

        let input = BeMatch.CreateInvitationInput(code: state.code)
        return .run { send in
          await send(.createInvitationResponse(Result {
            try await bematch.createInvitation(input)
          }))
        }
        .cancellable(id: Cancel.createInvitation, cancelInFlight: true)

      case .skipButtonTapped:
        return .send(.delegate(.nextScreen))

      case .createInvitationResponse(.success):
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.nextScreen))

      case .createInvitationResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .binding:
        state.isDisabled = state.code.count < 6
        return .none

      default:
        return .none
      }
    }
  }
}

public struct InvitationView: View {
  @FocusState var isFocused: Bool
  let store: StoreOf<InvitationLogic>

  public init(store: StoreOf<InvitationLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 32) {
        Text("If you have an invitation code.\nPlease let us know.", bundle: .module)
          .frame(height: 50)
          .font(.system(.title3, weight: .semibold))

        TextField(text: viewStore.$code) {
          Text("Invitation Code", bundle: .module)
        }
        .foregroundStyle(Color.white)
        .keyboardType(.alphabet)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .focused($isFocused)
        .font(.system(.title3, weight: .semibold))

        Spacer()

        VStack(spacing: 0) {
          PrimaryButton(
            String(localized: "Next", bundle: .module),
            isLoading: viewStore.isActivityIndicatorVisible,
            isDisabled: viewStore.isDisabled
          ) {
            store.send(.nextButtonTapped)
          }

          Button {
            store.send(.skipButtonTapped)
          } label: {
            Text("Skip", bundle: .module)
              .frame(height: 50)
              .foregroundStyle(Color.white)
              .font(.system(.subheadline, weight: .semibold))
          }
        }
      }
      .padding(.top, 24)
      .padding(.bottom, 16)
      .padding(.horizontal, 16)
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear {
        isFocused = true
      }
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
    InvitationView(
      store: .init(
        initialState: InvitationLogic.State(),
        reducer: { InvitationLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
