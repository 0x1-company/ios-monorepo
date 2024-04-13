import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import DirectMessageFeature
import FeedbackGeneratorClient
import ReportFeature
import SwiftUI

@Reducer
public struct ProfileExplorerLogic {
  public init() {}

  public enum Tab: Hashable {
    case message
    case profile
  }

  public struct State: Equatable {
    let username: String
    let targetUserId: String

    @BindingState var currentTab: Tab
    @BindingState var text = ""

    var directMessage: DirectMessageLogic.State
    var preview: ProfileExplorerPreviewLogic.State
    @PresentationState var destination: Destination.State?

    var isDisabled: Bool {
      return text.isEmpty
    }

    public init(
      username: String,
      targetUserId: String,
      tab: Tab = Tab.message
    ) {
      currentTab = tab
      self.username = username
      self.targetUserId = targetUserId
      directMessage = DirectMessageLogic.State(
        targetUserId: targetUserId
      )
      preview = ProfileExplorerPreviewLogic.State(
        targetUserId: targetUserId
      )
    }
  }

  public enum Action: BindableAction {
    case onTask
    case principalButtonTapped
    case unmatchButtonTapped
    case reportButtonTapped
    case blockButtonTapped
    case sendButtonTapped
    case binding(BindingAction<State>)
    case directMessage(DirectMessageLogic.Action)
    case preview(ProfileExplorerPreviewLogic.Action)
    case destination(PresentationAction<Destination.Action>)
    case createMessageResponse(Result<BeMatch.CreateMessageMutation.Data, Error>)
      case deleteMatchResponse(Result<BeMatch.DeleteMatchMutation.Data, Error>)
    case delegate(Delegate)
      public enum Delegate: Equatable {
        case unmatch(String)
      }
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator
    @Dependency(\.bematch.deleteMatch) var deleteMatch
    @Dependency(\.dismiss) var dismiss

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Scope(state: \.directMessage, action: \.directMessage) {
      DirectMessageLogic()
    }
    Scope(state: \.preview, action: \.preview) {
      ProfileExplorerPreviewLogic()
    }
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ProfileExplorer", of: self)
        return .none

      case .principalButtonTapped:
        state.currentTab = Tab.profile
        return .none

      case .sendButtonTapped where !state.isDisabled:
        let input = BeMatch.CreateMessageInput(
          targetUserId: state.targetUserId,
          text: state.text
        )
        state.text.removeAll()
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.createMessageResponse(Result {
            try await bematch.createMessage(input)
          }))
        }
      
      case .unmatchButtonTapped, .blockButtonTapped:
          state.destination = .confirmationDialog(
            ConfirmationDialogState {
              TextState("Unmatch", bundle: .module)
            } actions: {
              ButtonState(role: .destructive, action: .confirm) {
                TextState("Confirm", bundle: .module)
              }
            } message: {
              TextState("Are you sure you want to unmatch?", bundle: .module)
            }
          )
          return .none

      case .reportButtonTapped:
        state.destination = .report(ReportLogic.State(targetUserId: state.targetUserId))
        return .none

      case let .directMessage(.child(.content(.rows(.element(id, .reportButtonTapped))))):
        state.destination = .report(ReportLogic.State(messageId: id))
        return .none

      case .createMessageResponse(.success):
        return DirectMessageLogic()
          .reduce(into: &state.directMessage, action: .onTask)
          .map(Action.directMessage)

      case .deleteMatchResponse:
          let targetUserId = state.targetUserId
        return .run { send in
          await send(.delegate(.unmatch(targetUserId)))
          await dismiss()
        }
          
      case .destination(.presented(.confirmationDialog(.confirm))):
        state.destination = nil
        let input = BeMatch.DeleteMatchInput(targetUserId: state.targetUserId)

        return .run { send in
          await send(.deleteMatchResponse(Result {
            try await deleteMatch(input)
          }))
        }

      case .destination(.dismiss):
        state.destination = nil
        return .none

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case report(ReportLogic.State)
      case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
    }

    public enum Action {
      case report(ReportLogic.Action)
        case confirmationDialog(ConfirmationDialog)
        public enum ConfirmationDialog: Equatable {
          case confirm
        }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.report, action: \.report, child: ReportLogic.init)
        Scope(state: \.confirmationDialog, action: \.confirmationDialog) {}
    }
  }
}

public struct ProfileExplorerView: View {
  @FocusState var focus: Bool
  let store: StoreOf<ProfileExplorerLogic>

  public init(store: StoreOf<ProfileExplorerLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        TabView(selection: viewStore.$currentTab) {
          DirectMessageView(store: store.scope(state: \.directMessage, action: \.directMessage))
            .tag(ProfileExplorerLogic.Tab.message)

          ProfileExplorerPreviewView(store: store.scope(state: \.preview, action: \.preview))
            .tag(ProfileExplorerLogic.Tab.profile)
        }
        .onTapGesture {
          focus = false
        }

        HStack(spacing: 8) {
          TextField(
            text: viewStore.$text,
            axis: .vertical
          ) {
            Text("Message", bundle: .module)
          }
          .focused($focus)
          .lineLimit(1 ... 10)
          .padding(.vertical, 8)
          .padding(.horizontal, 16)
          .tint(Color.white)
          .background(Color(uiColor: UIColor.tertiarySystemBackground))
          .clipShape(RoundedRectangle(cornerRadius: 26))

          Button {
            store.send(.sendButtonTapped, animation: .default)
          } label: {
            Image(systemName: "paperplane.fill")
              .foregroundStyle(Color.primary)
          }
          .disabled(viewStore.isDisabled)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar(.hidden, for: .tabBar)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Button {
            store.send(.principalButtonTapped, animation: .default)
          } label: {
            Text(viewStore.username)
              .foregroundStyle(Color.primary)
              .font(.system(.callout, weight: .semibold))
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Menu {
              Button(role: .destructive) {
                store.send(.unmatchButtonTapped)
              } label: {
                Label {
                  Text("Unmatch", bundle: .module)
                } icon: {
                  Image(systemName: "trash")
                }
              }

            Button {
              store.send(.reportButtonTapped)
            } label: {
              Label {
                Text("Report", bundle: .module)
              } icon: {
                Image(systemName: "exclamationmark.triangle")
              }
            }

            Button {
                store.send(.blockButtonTapped)
            } label: {
              Text("Block", bundle: .module)
            }
          } label: {
            Image(systemName: "ellipsis")
              .bold()
              .foregroundStyle(Color.white)
              .frame(width: 44, height: 44)
          }
        }
      }
      .sheet(
        store: store.scope(state: \.$destination.report, action: \.destination.report),
        content: ReportView.init(store:)
      )
      .confirmationDialog(
        store: store.scope(
          state: \.$destination.confirmationDialog,
          action: \.destination.confirmationDialog
        )
      )
    }
  }
}

#Preview {
  NavigationStack {
    ProfileExplorerView(
      store: .init(
        initialState: ProfileExplorerLogic.State(
          username: "tomokisun",
          targetUserId: "id"
        ),
        reducer: { ProfileExplorerLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
