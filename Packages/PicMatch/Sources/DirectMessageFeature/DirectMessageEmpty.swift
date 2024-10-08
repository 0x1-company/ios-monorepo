import ComposableArchitecture
import DirectMessageLogic
import Styleguide
import SwiftUI

public struct DirectMessageEmptyView: View {
  @Bindable var store: StoreOf<DirectMessageEmptyLogic>

  public init(store: StoreOf<DirectMessageEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 0) {
      VStack(spacing: 24) {
        Image(ImageResource.yes)

        VStack(spacing: 8) {
          Text("Matched with \(store.displayName)!", bundle: .module)
            .font(.system(.title3, weight: .semibold))

          Text("Add Instagram and send a message!", bundle: .module)
        }
        .multilineTextAlignment(.center)

        PrimaryButton(
          String(localized: "Add Instagram", bundle: .module)
        ) {
          store.send(.jumpExternalProductButtonTapped)
        }
      }
      .frame(maxHeight: .infinity)

      Text("The operator may check and delete the contents of messages for the purpose of operating a sound service. In addition, the account may be suspended if inappropriate use is confirmed.", bundle: .module)
        .font(.caption)
        .foregroundStyle(Color.secondary)
    }
    .padding(.bottom, 8)
    .padding(.horizontal, 16)
  }
}

#Preview {
  NavigationStack {
    DirectMessageEmptyView(
      store: .init(
        initialState: DirectMessageEmptyLogic.State(
          displayName: "tomokisun",
          externalProductUrl: "https://bere.al/tomokisun",
          tentenPinCode: "du9v5pq"
        ),
        reducer: { DirectMessageEmptyLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
