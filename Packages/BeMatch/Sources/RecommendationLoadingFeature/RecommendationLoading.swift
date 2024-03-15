import AnalyticsClient
import ComposableArchitecture
import SwiftUI

@Reducer
public struct RecommendationLoadingLogic {
  public init() {}

  @ObservableState
  public struct State {
    public init() {}
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

public struct RecommendationLoadingView: View {
  @Perception.Bindable var store: StoreOf<RecommendationLoadingLogic>

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
