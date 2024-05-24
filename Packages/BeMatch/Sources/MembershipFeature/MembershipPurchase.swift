import ComposableArchitecture
import MembershipLogic
import Styleguide
import SwiftUI

public struct MembershipPurchaseView: View {
  let store: StoreOf<MembershipPurchaseLogic>

  public init(store: StoreOf<MembershipPurchaseLogic>) {
    self.store = store
  }

  var gradient: LinearGradient {
    LinearGradient(
      colors: [
        Color(0xFFE8_B423),
        Color(0xFFF5_D068),
      ],
      startPoint: .leading,
      endPoint: .trailing
    )
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ZStack(alignment: .top) {
        Color.yellow
          .frame(width: 190, height: 190)
          .clipShape(Circle())
          .offset(y: -190)
          .blur(radius: 64)

        VStack(spacing: 16) {
          ScrollView {
            VStack(spacing: 16) {
              Text("Premium Plan", bundle: .module)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .overlay(
                  Capsule()
                    .stroke(Color.white, lineWidth: 1)
                )

              Text("Find someone you care about!", bundle: .module)
                .font(.system(.title2, weight: .bold))

              SpecialOfferView()

              PurchaseAboutView(
                displayPrice: viewStore.displayPrice
              )
            }
            .padding(.bottom, 48)
            .padding(.horizontal, 16)
          }

          Button {
            store.send(.upgradeButtonTapped)
          } label: {
            Text("Upgrade for \(viewStore.displayPrice)/week", bundle: .module)
          }
          .buttonStyle(ConversionPrimaryButtonStyle())
          .padding(.horizontal, 16)
          .padding(.bottom, 36)
        }
        .task { await store.send(.onTask).finish() }
      }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.logo)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    MembershipPurchaseView(
      store: .init(
        initialState: MembershipPurchaseLogic.State(
          displayPrice: "¥500"
        ),
        reducer: { MembershipPurchaseLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
