import AnalyticsClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct MembershipPurchaseLogic {
  public init() {}

  public struct State: Equatable {
    let displayPrice: String

    public init(displayPrice: String) {
      self.displayPrice = displayPrice
    }
  }

  public enum Action {
    case onTask
    case upgradeButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case purchase
    }
  }

  @Dependency(\.analytics) var analytics

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "MembershipPurchase", of: self)
        return .none

      case .upgradeButtonTapped:
        return .send(.delegate(.purchase))

      default:
        return .none
      }
    }
  }
}

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
            Image(ImageResource.purchaseHeader)
              .resizable()

            VStack(spacing: 40) {
              Button {
                store.send(.upgradeButtonTapped)
              } label: {
                Text("Upgrade for \(viewStore.displayPrice)/week", bundle: .module)
              }
              .buttonStyle(ConversionPrimaryButtonStyle())

              VStack(spacing: 60) {
                Image(ImageResource.membershipBenefit)
                  .resizable()

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
