import ActivityView
import ComposableArchitecture
import RecommendationLogic
import Styleguide
import SwiftUI

public struct RecommendationEmptyView: View {
  @Bindable var store: StoreOf<RecommendationEmptyLogic>

  public init(store: StoreOf<RecommendationEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 40) {
      Image(ImageResource.break)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 37)

      VStack(spacing: 16) {
        Text("Too much swiping...\nPlease help us share TenMatch... 🙏", bundle: .module)
          .font(.system(.subheadline, design: .rounded, weight: .semibold))
          .foregroundStyle(Color.white)
          .multilineTextAlignment(.center)

        Button {
          store.send(.shareButtonTapped)
        } label: {
          Text("Share", bundle: .module)
            .font(.system(.subheadline, design: .rounded, weight: .semibold))
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.black)
            .background(Color.white)
            .cornerRadius(16)
        }
        .buttonStyle(HoldDownButtonStyle())
      }
      .padding(.horizontal, 16)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(
      LinearGradient(
        colors: [
          Color(0xFFB8_5BE9),
          Color(0xFF00_0000),
        ],
        startPoint: .topTrailing,
        endPoint: .bottomLeading
      )
    )
    .task { await store.send(.onTask).finish() }
    .sheet(isPresented: $store.isPresented) {
      ActivityView(
        activityItems: [store.shareText],
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

#Preview {
  NavigationStack {
    RecommendationEmptyView(
      store: .init(
        initialState: RecommendationEmptyLogic.State(),
        reducer: { RecommendationEmptyLogic() }
      )
    )
    .toolbar {
      ToolbarItem(placement: .principal) {
        Image(ImageResource.logo)
      }
    }
  }
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
