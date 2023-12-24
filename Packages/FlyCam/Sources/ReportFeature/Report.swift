import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct ReportLogic {
  public init() {}

  public struct State: Equatable {
    let targetUserId: String

    var path = StackState<Path.State>()

    public init(targetUserId: String) {
      self.targetUserId = targetUserId
    }
  }

  public enum Action {
    case onTask
    case onAppear
    case titleButtonTapped(String)
    case path(StackAction<Path.State, Path.Action>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        analytics.logScreen(screenName: "Report", of: self)
        return .none

      case let .titleButtonTapped(title):
        state.path.append(.reason(ReportReasonLogic.State(
          targetUserId: state.targetUserId,
          title: title
        )))
        return .none

      case .path(.element(_, .reason(.delegate(.dismiss)))):
        state.path.removeAll()
        return .run { _ in
          await dismiss()
        }

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path) {
      Path()
    }
  }

  @Reducer
  public struct Path {
    public enum State: Equatable {
      case reason(ReportReasonLogic.State)
    }

    public enum Action {
      case reason(ReportReasonLogic.Action)
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.reason, action: \.reason, child: ReportReasonLogic.init)
    }
  }
}

public struct ReportView: View {
  let store: StoreOf<ReportLogic>

  public init(store: StoreOf<ReportLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStackStore(
      store.scope(state: \.path, action: \.path)
    ) {
      List(
        [
          String(localized: "Spam", bundle: .module),
          String(localized: "Nudity or something sexualy explicit", bundle: .module),
          String(localized: "Violent or dangerous", bundle: .module),
          String(localized: "Suicide or self-harm", bundle: .module),
          String(localized: "Fake profile", bundle: .module),
          String(localized: "Other", bundle: .module),
        ],
        id: \.self
      ) { title in
        Button {
          store.send(.titleButtonTapped(title))
        } label: {
          LabeledContent {
            Image(systemName: "chevron.right")
          } label: {
            Text(title)
              .foregroundStyle(Color.primary)
          }
        }
      }
      .navigationTitle(String(localized: "Report a FlyCam.", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
    } destination: { store in
      SwitchStore(store) { initialState in
        switch initialState {
        case .reason:
          CaseLet(
            /ReportLogic.Path.State.reason,
            action: ReportLogic.Path.Action.reason,
            then: ReportReasonView.init(store:)
          )
        }
      }
    }
    .tint(Color.white)
  }
}

#Preview {
  Color.white
    .sheet(isPresented: .constant(true)) {
      ReportView(
        store: .init(
          initialState: ReportLogic.State(
            targetUserId: String()
          ),
          reducer: { ReportLogic() }
        )
      )
      .presentationDragIndicator(.visible)
      .presentationDetents([.medium, .large])
      .environment(\.colorScheme, .dark)
      .environment(\.locale, Locale(identifier: "ja-JP"))
    }
}
