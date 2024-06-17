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
        Image(ImageResource.matched)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxHeight: .infinity)

        VStack(spacing: 12) {
          PrimaryButton(
            String(localized: "Add ten ten", bundle: .module)
          ) {
            store.send(.addExternalProductButtonTapped)
          }

          Text("🔗 \(viewStore.displayExternalProductURL)", bundle: .module)
            .foregroundStyle(Color.white)
            .font(.system(.caption, design: .rounded, weight: .semibold))
        }
      }
      .padding(.horizontal, 16)
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
            .bold()
            .foregroundStyle(Color.white)
            .padding(.all, 24)
        }
      }
      .background(
        Color.clear
          .compositingGroup()
          .onTapGesture {
            store.send(.closeButtonTapped)
          }
      )
      .presentationBackground(Color.black.opacity(0.95))
    }
  }
}

#Preview {
  NavigationStack {
    Color.black
      .ignoresSafeArea()
      .fullScreenCover(isPresented: .constant(true)) {
        MatchedView(
          store: .init(
            initialState: MatchedLogic.State(
              externalProductURL: URL(string: "https://bere.al/tomokisun")!
            ),
            reducer: { MatchedLogic() }
          )
        )
      }
  }
  .environment(\.colorScheme, .dark)
}
