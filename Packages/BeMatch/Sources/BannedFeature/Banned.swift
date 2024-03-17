import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct BannedLogic {
  public init() {}

  public struct State: Equatable {
    var userId: String
    public init(userId: String) {
      self.userId = userId
    }
  }

  public enum Action {
    case onTask
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Banned", of: self)
        return .none
      }
    }
  }
}

public struct BannedView: View {
  let store: StoreOf<BannedLogic>

  public init(store: StoreOf<BannedLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 24) {
        Text("Your account has been banned from BeMatch.", bundle: .module)
          .font(.system(.headline, weight: .semibold))

        Text("It's important to us that BeMatch is a welcoming and safe space for everyone.\nUnfortunately, we found that you violated our Terms of Use and so we've made the decision to remove you from the BeMatch Platform.", bundle: .module)
          .font(.system(.body, weight: .semibold))
          .foregroundStyle(Color.secondary)

        Text("You will no longer be able to access your BeMatch account or create new accounts in the future.", bundle: .module)
          .font(.system(.body, weight: .semibold))
          .foregroundStyle(Color.secondary)

        Text("id: \(viewStore.userId)")
          .font(.system(.body, weight: .semibold))
          .foregroundStyle(Color.secondary)
      }
      .padding(.horizontal, 16)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background()
      .multilineTextAlignment(.center)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  BannedView(
    store: .init(
      initialState: BannedLogic.State(
        userId: "71ff7640-cbad-4d50-9c10-ac07910a075d"
      ),
      reducer: { BannedLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
