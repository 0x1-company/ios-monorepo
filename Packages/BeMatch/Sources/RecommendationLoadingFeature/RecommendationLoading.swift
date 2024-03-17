import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct RecommendationLoadingLogic {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

public struct RecommendationLoadingView: View {
  let store: StoreOf<RecommendationLoadingLogic>

  public init(store: StoreOf<RecommendationLoadingLogic>) {
    self.store = store
  }

  public var body: some View {
    ProgressView()
      .tint(Color.white)
      .progressViewStyle(CircularProgressViewStyle())
  }
}

#Preview {
  RecommendationLoadingView(
    store: .init(
      initialState: RecommendationLoadingLogic.State(),
      reducer: { RecommendationLoadingLogic() }
    )
  )
}
