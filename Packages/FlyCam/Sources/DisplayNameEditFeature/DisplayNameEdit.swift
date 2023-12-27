import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient
import FlyCam
import FlyCamClient
import Styleguide
import SwiftUI

@Reducer
public struct DisplayNameEditLogic {
  public init() {}

  public struct State: Equatable {
    var isDisabled = true
    var isActivityIndicatorVisible = false
    @BindingState var displayName = String()

    public init() {}
  }

  public enum Action: BindableAction {
    case onTask
    case closeButtonTapped
    case saveButtonTapped
    case binding(BindingAction<State>)
    case currentUserResponse(Result<FlyCam.CurrentUserQuery.Data, Error>)
    case updateDisplayNameResponse(Result<FlyCam.UpdateDisplayNameMutation.Data, Error>)
  }

  @Dependency(\.flycam) var flycam
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "DisplayNameEdit", of: self)
        return .run { send in
          for try await data in flycam.currentUser() {
            await send(.currentUserResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)))
        }

      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case .saveButtonTapped:
        state.isActivityIndicatorVisible = true
        let input = FlyCam.UpdateDisplayNameInput(displayName: state.displayName)
        return .merge(
          .run(operation: { send in
            await send(.updateDisplayNameResponse(Result {
              try await flycam.updateDisplayName(input)
            }))
          }),
          .run(operation: { _ in
            await feedbackGenerator.impactOccurred()
          })
        )

      case .binding(\.$displayName):
        state.isDisabled = state.displayName.isEmpty
        return .none

      case let .currentUserResponse(.success(data)):
        state.displayName = data.currentUser.displayName
        return .none

      case .updateDisplayNameResponse:
        state.isActivityIndicatorVisible = false
        return .run { _ in
          await dismiss()
        }

      default:
        return .none
      }
    }
  }
}

public struct DisplayNameEditView: View {
  @FocusState var isFocused: Bool
  let store: StoreOf<DisplayNameEditLogic>

  public init(store: StoreOf<DisplayNameEditLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 32) {
        Text("What's your display name?", bundle: .module)
          .font(.system(.title3, weight: .semibold))

        TextField(text: viewStore.$displayName) {
          Text("Display Name", bundle: .module)
        }
        .foregroundStyle(Color.white)
        .keyboardType(.alphabet)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
        .focused($isFocused)
        .font(.system(.title3, weight: .semibold))

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
      .padding(.bottom, 16)
      .padding(.horizontal, 16)
      .multilineTextAlignment(.center)
      .navigationTitle("FlyCam")
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear {
        isFocused = true
      }
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "chevron.down")
              .foregroundStyle(Color.primary)
          }
        }
      }
    }
  }
}

#Preview {
  DisplayNameEditView(
    store: .init(
      initialState: DisplayNameEditLogic.State(),
      reducer: { DisplayNameEditLogic() }
    )
  )
}
