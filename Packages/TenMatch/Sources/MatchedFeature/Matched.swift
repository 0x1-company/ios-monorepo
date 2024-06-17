import ComposableArchitecture
import MatchedLogic
import Styleguide
import SwiftUI

public struct MatchedView: View {
  @Environment(\.requestReview) var requestReview
  let store: StoreOf<MatchedLogic>

  public init(store: StoreOf<MatchedLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        VStack(spacing: 16) {
          Image(ImageResource.matched)
            .resizable()
            .aspectRatio(contentMode: .fit)

          HStack(spacing: 8) {
            Color.blue
              .clipShape(Circle())
              .frame(width: 128, height: 128)

            Color.blue
              .clipShape(Circle())
              .frame(width: 128, height: 128)
          }

          Text("You matched with XXXX", bundle: .module)
            .foregroundStyle(Color.white)
            .font(.system(.headline, design: .rounded, weight: .semibold))
        }
        .frame(maxHeight: .infinity)

        VStack(spacing: 12) {
          PrimaryButton(
            String(localized: "Copy tenten's PIN", bundle: .module)
          ) {
            store.send(.addExternalProductButtonTapped)
          }

          Text("🧷 \(viewStore.displayExternalProductURL)", bundle: .module)
            .foregroundStyle(Color.white)
            .font(.system(.caption, design: .rounded, weight: .semibold))
        }
      }
      .padding(.horizontal, 37)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .task {
        requestReview()
        await store.send(.onTask).finish()
      }
      .overlay(alignment: .topLeading) {
        Button {
          store.send(.closeButtonTapped)
        } label: {
          Image(systemName: "xmark")
            .font(.system(size: 12, weight: .regular))
            .frame(width: 36, height: 36)
            .foregroundStyle(Color.white)
            .background(Color(uiColor: UIColor.quaternarySystemFill))
            .clipShape(Circle())
        }
        .padding(.horizontal, 12)
      }
      .background(
        LinearGradient(
          colors: [
            Color(0xFF30_D158),
            Color(0xFFFF_D60A),
            Color(0xFFFF_2E00),
            Color(0xFF00_0000),
          ],
          startPoint: .top,
          endPoint: .bottom
        )
      )
    }
  }
}

#Preview {
  NavigationStack {
    MatchedView(
      store: .init(
        initialState: MatchedLogic.State(
          externalProductURL: URL(string: "https://bere.al/tomokisun")!
        ),
        reducer: { MatchedLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
