import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct AchievementLogic {
  public init() {}

  public struct State: Equatable {
    var list: AchievementListLogic.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case closeButtonTapped
    case achievementResponse(Result<BeMatch.AchievementQuery.Data, Error>)
    case list(AchievementListLogic.Action)
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Achievement", of: self)
        return .run { send in
          for try await data in bematch.achievement() {
            await send(.achievementResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.achievementResponse(.failure(error)))
        }
        
      case .closeButtonTapped:
        return .none

      case let .achievementResponse(.success(data)):
        state.list = AchievementListLogic.State(
          achievement: data.achievement
        )
        return .none

      case .achievementResponse(.failure):
        state.list = nil
        return .none
      }
    }
    .ifLet(\.list, action: \.list) {
      AchievementListLogic()
    }
  }
}

public struct AchievementView: View {
  let store: StoreOf<AchievementLogic>

  public init(store: StoreOf<AchievementLogic>) {
    self.store = store
  }

  public var body: some View {
    IfLetStore(
      store.scope(state: \.list, action: \.list),
      then: AchievementListView.init(store:),
      else: {
        Color.black
          .overlay {
            ProgressView()
              .tint(Color.white)
          }
      }
    )
    .navigationTitle(String(localized: "Achievement", bundle: .module))
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
//    .overlay(alignment: .bottom) {
//      Button {} label: {
//        Label("Share", systemImage: "square.and.arrow.up")
//          .padding(.vertical, 16)
//          .padding(.horizontal, 24)
//          .foregroundStyle(Color.primary)
//          .font(.system(.subheadline, weight: .semibold))
//          .background(Color(uiColor: UIColor.systemFill))
//          .clipShape(RoundedRectangle(cornerRadius: 16))
//      }
//      .padding(.bottom, 16)
//    }
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
  }
}

#Preview {
  NavigationStack {
    AchievementView(
      store: .init(
        initialState: AchievementLogic.State(),
        reducer: { AchievementLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
