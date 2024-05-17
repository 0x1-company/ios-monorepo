import ComposableArchitecture
import FreezedLogic
import Styleguide
import SwiftUI

public struct FreezedView: View {
  let store: StoreOf<FreezedLogic>

  public init(store: StoreOf<FreezedLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      Image(ImageResource.no)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 120)

      Text("Currently unable to re-register", bundle: .module)
        .font(.system(.title3, weight: .semibold))

      Text("Once you have deleted your TapMatch account, you will not be able to register again for a certain period of time after the deletion.", bundle: .module)

      Text("Please answer our simple questionnaire to help us improve our service.", bundle: .module)

      PrimaryButton(
        String(localized: "Answer", bundle: .module)
      ) {
        print(#function)
      }
    }
    .padding(.horizontal, 16)
    .multilineTextAlignment(.center)
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  NavigationStack {
    FreezedView(
      store: .init(
        initialState: FreezedLogic.State(),
        reducer: { FreezedLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
