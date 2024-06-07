import ActivityView
import ComposableArchitecture
import MembershipLogic
import ProductPurchaseFeature
import SwiftUI

public struct MembershipView: View {
  let store: StoreOf<MembershipLogic>

  public init(store: StoreOf<MembershipLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack {
      WithViewStore(store, observe: { $0 }) { viewStore in
        SwitchStore(store.scope(state: \.child, action: \.child)) { initialState in
          switch initialState {
          case .loading:
            ProgressView()
              .tint(Color.white)
          case .campaign:
            CaseLet(
              /MembershipLogic.Child.State.campaign,
              action: MembershipLogic.Child.Action.campaign,
              then: MembershipCampaignView.init(store:)
            )
          case .purchase:
            CaseLet(
              /MembershipLogic.Child.State.purchase,
              action: MembershipLogic.Child.Action.purchase,
              then: MembershipPurchaseView.init(store:)
            )
          }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task { await store.send(.onTask).finish() }
        .alert(store: store.scope(state: \.$destination.alert, action: \.destination.alert))
        .toolbar {
          ToolbarItem(placement: .topBarLeading) {
            Button {
              store.send(.closeButtonTapped)
            } label: {
              Image(systemName: "xmark")
                .font(.system(size: 12, weight: .regular))
                .frame(width: 32, height: 32)
                .foregroundStyle(Color.primary)
                .background(Color(uiColor: UIColor.quaternarySystemFill))
                .clipShape(Circle())
            }
          }
        }
        .fullScreenCover(
          store: store.scope(state: \.$destination.purchase, action: \.destination.purchase)
        ) { store in
          NavigationStack {
            ProductPurchaseView(store: store)
          }
        }
        .sheet(isPresented: viewStore.$isPresented) {
          ActivityView(
            activityItems: [viewStore.shareText],
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
