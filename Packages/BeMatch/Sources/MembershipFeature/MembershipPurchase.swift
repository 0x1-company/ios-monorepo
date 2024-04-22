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
      VStack(spacing: 16) {
        ScrollView {
          VStack(spacing: 24) {
            VStack(spacing: 16) {
              Text("Premium Plan", bundle: .module)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.vertical, 6)
                .padding(.horizontal, 8)
                .overlay(
                  RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.white, lineWidth: 1)
                )

              Image(ImageResource.bematchPro)

              Text("Find someone you care about!", bundle: .module)
                .font(.title2)
                .bold()
            }

            VStack(spacing: 40) {
              Button {
                store.send(.upgradeButtonTapped)
              } label: {
                Text("Upgrade for \(viewStore.displayPrice)/week", bundle: .module)
              }
              .buttonStyle(ConversionPrimaryButtonStyle())

              VStack(spacing: 60) {
                SpecialOfferView()

                PurchaseAboutView(
                  displayPrice: viewStore.displayPrice
                )
              }
            }
          }
          .padding(.top, 96)
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
      .background()
      .task { await store.send(.onTask).finish() }
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
