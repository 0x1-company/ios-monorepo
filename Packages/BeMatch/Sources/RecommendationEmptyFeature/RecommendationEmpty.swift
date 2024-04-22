import ActivityView
import ComposableArchitecture
import RecommendationEmptyLogic
import Styleguide
import SwiftUI

public struct RecommendationEmptyView: View {
  let store: StoreOf<RecommendationEmptyLogic>

  public init(store: StoreOf<RecommendationEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 40) {
        Image(ImageResource.highAlert)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 160)

        VStack(spacing: 16) {
          Text("Just a little... Too much swiping... Please help me share BeMatch... 🙏.", bundle: .module)
            .font(.system(.subheadline, weight: .semibold))
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.center)

          Button {
            store.send(.shareButtonTapped)
          } label: {
            Text("Share", bundle: .module)
              .font(.system(.subheadline, weight: .semibold))
              .frame(height: 50)
              .frame(maxWidth: .infinity)
              .foregroundStyle(Color.black)
              .background(Color.white)
              .cornerRadius(16)
          }
          .buttonStyle(HoldDownButtonStyle())
        }
      }
      .padding(.horizontal, 16)
      .background(Color.black)
      .task { await store.send(.onTask).finish() }
      .sheet(isPresented: viewStore.$isPresented) {
        ActivityView(
          activityItems: [viewStore.shareText],
          applicationActivities: nil
        ) { activityType, result, _, _ in
          store.send(
            .onCompletion(
              RecommendationEmptyLogic.CompletionWithItems(
                activityType: activityType,
                result: result
              )
            )
          )
        }
        .presentationDetents([.medium, .large])
      }
    }
  }
}

#Preview {
  RecommendationEmptyView(
    store: .init(
      initialState: RecommendationEmptyLogic.State(),
      reducer: { RecommendationEmptyLogic() }
    )
  )
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
