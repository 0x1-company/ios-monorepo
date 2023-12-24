import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct ReportReasonLogic {
  public init() {}

  public struct State: Equatable {
    let title: String
    let targetUserId: String

    var isDisabled = true
    var isActivityIndicatorVisible = false
    @BindingState var text = String()
    @BindingState var focus: Field?
    @PresentationState var alert: AlertState<Action.Alert>?

    public init(
      targetUserId: String,
      title: String
    ) {
      self.title = title
      self.targetUserId = targetUserId
    }

    enum Field: Hashable {
      case text
    }
  }

  public enum Action: BindableAction {
    case onTask
    case onAppear
    case sendButtonTapped
    case binding(BindingAction<State>)
    case alert(PresentationAction<Alert>)
    case delegate(Delegate)
    case createReportResponse(Result<BeMatch.CreateReportMutation.Data, Error>)

    public enum Alert: Equatable {
      case confirmOkay
    }

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.createReport) var createReport
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "ReportReason", of: self)
        return .none

      case .sendButtonTapped:
        let input = BeMatch.CreateReportInput(
          targetUserId: state.targetUserId,
          text: state.text,
          title: state.title
        )
        state.isActivityIndicatorVisible = true
        return .run { send in
          await withTaskGroup(of: Void.self) { group in
            group.addTask {
              await feedbackGenerator.impactOccurred()
            }
            group.addTask {
              await send(.createReportResponse(Result {
                try await createReport(input)
              }))
            }
          }
        }

      case .binding:
        state.isDisabled = state.text.count <= 10
        return .none

      case .alert(.presented(.confirmOkay)):
        state.alert = nil
        return .send(.delegate(.dismiss), animation: .default)

      case .createReportResponse:
        state.focus = nil
        state.isActivityIndicatorVisible = false
        state.alert = AlertState {
          TextState("Reported.", bundle: .module)
        } actions: {
          ButtonState(action: .confirmOkay) {
            TextState("OK", bundle: .module)
          }
        }
        return .none

      default:
        return .none
      }
    }
  }
}

public struct ReportReasonView: View {
  @FocusState var focus: ReportReasonLogic.State.Field?
  let store: StoreOf<ReportReasonLogic>

  public init(store: StoreOf<ReportReasonLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 16) {
        VStack(alignment: .leading, spacing: 0) {
          Text("Your report is confidential.", bundle: .module)

          Text("If you or someone you know is in immediate danger, contact local low enforcement or your local emergency services immediately.", bundle: .module)
            .layoutPriority(1)
            .frame(minHeight: 50)
        }
        .font(.system(.footnote))

        VStack(alignment: .leading, spacing: 8) {
          TextEditor(text: viewStore.$text)
            .frame(height: 140)
            .lineLimit(1 ... 10)
            .focused($focus, equals: .text)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary, lineWidth: 1.0)
            )

          Text("Minimum of 10 characters required.", bundle: .module)
            .foregroundStyle(Color.secondary)
            .font(.caption)
        }

        Spacer()

        PrimaryButton(
          String(localized: "Send", bundle: .module),
          isLoading: viewStore.isActivityIndicatorVisible,
          isDisabled: viewStore.isDisabled
        ) {
          store.send(.sendButtonTapped)
        }
      }
      .padding(.vertical, 24)
      .padding(.horizontal, 16)
      .formStyle(ColumnsFormStyle())
      .navigationTitle(Text("Report a BeMatch.", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .onAppear { store.send(.onAppear) }
      .bind(viewStore.$focus, to: $focus)
      .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
  }
}

#Preview {
  NavigationStack {
    ReportReasonView(
      store: .init(
        initialState: ReportReasonLogic.State(
          targetUserId: String(),
          title: String(localized: "Spam", bundle: .module)
        ),
        reducer: { ReportReasonLogic() }
      )
    )
  }
  .presentationDragIndicator(.visible)
  .presentationDetents([.medium, .large])
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
