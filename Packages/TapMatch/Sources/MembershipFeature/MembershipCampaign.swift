import API
import ComposableArchitecture
import MembershipLogic
import SwiftUI

public struct MembershipCampaignView: View {
  let store: StoreOf<MembershipCampaignLogic>

  public init(store: StoreOf<MembershipCampaignLogic>) {
    self.store = store
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
              InvitationCampaignView(
                store: store.scope(
                  state: \.invitationCampaign,
                  action: \.invitationCampaign
                )
              )
              .padding(.top, 16)

              InvitationCodeCampaignView(
                store: store.scope(
                  state: \.invitationCodeCampaign,
                  action: \.invitationCodeCampaign
                )
              )

              SpecialOfferView()

              HowToReceiveBenefitView(
                displayDuration: viewStore.displayDuration
              )

              PurchaseAboutView(
                displayPrice: viewStore.displayPrice
              )
            }
            .padding(.bottom, 80)
            .padding(.horizontal, 16)
          }

          VStack(spacing: 16) {
            Button {
              store.send(.invitationCodeButtonTapped)
            } label: {
              Text("Send Invitation Code", bundle: .module)
            }
            .buttonStyle(ConversionPrimaryButtonStyle())

            Button {
              store.send(.upgradeButtonTapped)
            } label: {
              Text("Upgrade for \(viewStore.displayPrice)/week", bundle: .module)
            }
            .buttonStyle(ConversionSecondaryButtonStyle())
          }
          .padding(.horizontal, 16)
          .padding(.bottom, 36)
        }
      }
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  MembershipCampaignView(
    store: .init(
      initialState: MembershipCampaignLogic.State(
        campaign: API.MembershipQuery.Data.ActiveInvitationCampaign(
          _dataDict: DataDict(
            data: [
              "id": "1",
              "quantity": 2000,
              "durationWeeks": 4,
            ],
            fulfilledFragments: []
          )
        ),
        code: "ABCDEF",
        displayPrice: "¥500",
        displayDuration: "1 week",
        currencyCode: "$",
        specialOfferDisplayPrice: "$100"
      ),
      reducer: { MembershipCampaignLogic() }
    )
  )
  .ignoresSafeArea()
  .environment(\.colorScheme, .dark)
//  .environment(\.locale, Locale(identifier: "ja-JP"))
}
