import ActivityView
import ComposableArchitecture
import MembershipLogic
import ProductPurchaseFeature
import SwiftUI

public struct MembershipView: View {
  @Bindable var store: StoreOf<MembershipLogic>

  public init(store: StoreOf<MembershipLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      Group {
        switch store.scope(state: \.child, action: \.child).state {
        case .loading:
          ProgressView()
            .tint(Color.white)
        case .campaign:
          if let store = store.scope(state: \.child.campaign, action: \.child.campaign) {
            MembershipCampaignView(store: store)
          }
        case .purchase:
          if let store = store.scope(state: \.child.purchase, action: \.child.purchase) {
            MembershipPurchaseView(store: store)
          }
        }
      }
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .alert($store.scope(state: \.destination?.alert, action: \.destination.alert))
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "xmark")
              .foregroundStyle(Color.primary)
          }
        }
      }
      .fullScreenCover(
        item: $store.scope(state: \.destination?.purchase, action: \.destination.purchase)
      ) { store in
        NavigationStack {
          ProductPurchaseView(store: store)
        }
      }
      .sheet(isPresented: $store.isPresented) {
        ActivityView(
          activityItems: [store.shareText],
          applicationActivities: nil
        ) { activityType, result, _, _ in
          store.send(
            .onCompletion(
              MembershipLogic.CompletionWithItems(
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
  MembershipView(
    store: .init(
      initialState: MembershipLogic.State(),
      reducer: { MembershipLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
