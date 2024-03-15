import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct ReportLogic {
  public init() {}

  public enum Kind: Hashable, Equatable {
    case user(targetUserId: String)
    case message(messageId: String)
  }

  @ObservableState
  public struct State: Equatable {
    let kind: Kind

    var path = StackState<Path.State>()

    public init(targetUserId: String) {
      kind = Kind.user(targetUserId: targetUserId)
    }

    public init(messageId: String) {
      kind = Kind.message(messageId: messageId)
    }
  }

  public enum Action {
    case onTask
    case titleButtonTapped(String)
    case closeButtonTapped
    case path(StackAction<Path.State, Path.Action>)
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Report", of: self)
        return .none

      case let .titleButtonTapped(title):
        state.path.append(.reason(ReportReasonLogic.State(
          title: title,
          kind: state.kind
        )))
        return .none

      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      case .path(.element(_, .reason(.delegate(.dismiss)))):
        state.path.removeAll()
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }

      default:
        return .none
      }
    }
    .forEach(\.path, action: \.path)
  }

  @Reducer(state: .equatable)
  public enum Path {
    case reason(ReportReasonLogic)
  }
}

public struct ReportView: View {
  @Perception.Bindable var store: StoreOf<ReportLogic>

  public init(store: StoreOf<ReportLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
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
      .navigationTitle(String(localized: "Report a BeMatch.", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "chevron.down")
              .bold()
              .foregroundStyle(Color.white)
              .frame(width: 44, height: 44)
          }
        }
      }
    } destination: { store in
      switch store.state {
      case .reason:
        if let store = store.scope(state: \.reason, action: \.reason) {
          ReportReasonView(store: store)
        }
      }
    }
    .tint(Color.white)
    .task { await store.send(.onTask).finish() }
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
