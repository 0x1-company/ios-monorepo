import ComposableArchitecture
import RecommendationLoadingLogic
import SwiftUI

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
