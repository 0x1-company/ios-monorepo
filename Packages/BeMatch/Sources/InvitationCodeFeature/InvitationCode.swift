import ComposableArchitecture
import InvitationCodeLogic
import Styleguide
import SwiftUI

public struct InvitationCodeView: View {
  let store: StoreOf<InvitationCodeLogic>

  public init(store: StoreOf<InvitationCodeLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        VStack(spacing: 16) {
          Image(ImageResource.inviteTicket)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .center) {
              Text(viewStore.code)
                .foregroundStyle(Color(0xFFFF_CC00))
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .offset(x: -35, y: 8)
            }
        }
        .padding(.all, 16)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
      }
      .padding(.vertical, 24)
      .background()
      .navigationTitle(String(localized: "Invitation Code", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    InvitationCodeView(
      store: .init(
        initialState: InvitationCodeLogic.State(),
        reducer: { InvitationCodeLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
