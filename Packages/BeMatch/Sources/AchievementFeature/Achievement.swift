import AchievementLogic
import ComposableArchitecture
import SwiftUI

public struct AchievementView: View {
  let store: StoreOf<AchievementLogic>

  public init(store: StoreOf<AchievementLogic>) {
    self.store = store
  }

  public var body: some View {
    SwitchStore(store) { initialState in
      switch initialState {
      case .loading:
        ProgressView()
          .tint(Color.white)

      case .content:
        CaseLet(
          /AchievementLogic.State.content,
          action: AchievementLogic.Action.content,
          then: AchievementContentView.init(store:)
        )
      }
    }
    .navigationTitle(String(localized: "Achievement", bundle: .module))
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .toolbar {
      ToolbarItem(placement: .topBarLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "xmark")
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
        initialState: AchievementLogic.State.loading,
        reducer: { AchievementLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
