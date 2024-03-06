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
  
  public enum ReportType: Hashable {
    case user(targetUserId: String)
    case message(messageId: String)
  }

  public struct State: Equatable {
    let title: String
    let reportType: ReportType

    var isDisabled = true
    var isActivityIndicatorVisible = false
    @BindingState var text = String()
    @BindingState var focus: Field?
    @PresentationState var alert: AlertState<Action.Alert>?

    public init(
      title: String,
      targetUserId: String
    ) {
      self.title = title
      self.reportType = .user(targetUserId: targetUserId)
    }
    
    public init(
      title: String,
      messageId: String
    ) {
      self.title = title
      self.reportType = .message(messageId: messageId)
    }

    enum Field: Hashable {
      case text
    }
  }

  public enum Action: BindableAction {
    case onTask
    case sendButtonTapped
    case binding(BindingAction<State>)
    case alert(PresentationAction<Alert>)
    case delegate(Delegate)
    case createReportResponse(Result<BeMatch.CreateReportMutation.Data, Error>)
    case createMessageReportResponse(Result<BeMatch.CreateMessageReportMutation.Data, Error>)

    public enum Alert: Equatable {
      case confirmOkay
    }

    public enum Delegate: Equatable {
      case dismiss
    }
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ReportReason", of: self)
        return .none

      case .sendButtonTapped:
        state.isActivityIndicatorVisible = true
        switch state.reportType {
        case let .user(targetUserId):
          let input = BeMatch.CreateReportInput(
            targetUserId: targetUserId,
            text: state.text,
            title: state.title
          )
          return .run { send in
            await feedbackGenerator.impactOccurred()
            await send(.createReportResponse(Result {
              try await bematch.createReport(input)
            }))
          }

        case let .message(messageId):
          let input = BeMatch.CreateMessageReportInput(
            messageId: messageId,
            text: state.text,
            title: state.title
          )
          return .run { send in
            await feedbackGenerator.impactOccurred()
            await send(.createMessageReportResponse(Result {
              try await bematch.createMessageReport(input)
            }))
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
    .ifLet(\.$alert, action: \.alert)
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
          title: String(localized: "Spam", bundle: .module),
          targetUserId: String()
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
