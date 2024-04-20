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
      VStack(spacing: 40) {
        Image(ImageResource.matched)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 240)

        VStack(spacing: 12) {
          PrimaryButton(
            String(localized: "Add BeReal.", bundle: .module)
          ) {
            store.send(.addBeRealButtonTapped)
          }

          Text("🔗 BeRe.al/\(viewStore.username)", bundle: .module)
            .font(.system(.caption, weight: .semibold))
        }
      }
      .padding(.horizontal, 16)
      .ignoresSafeArea()
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
      .presentationBackground(
        LinearGradient(
          colors: [
            Color(0xFFFE_7056),
            Color(0xFFFD_2D76),
          ],
          startPoint: .topTrailing,
          endPoint: .bottomLeading
        )
        .opacity(0.95)
      )
    }
  }
}

#Preview {
  Color.black
    .ignoresSafeArea()
    .fullScreenCover(isPresented: .constant(true)) {
      MatchedView(
        store: .init(
          initialState: MatchedLogic.State(
            username: "tomokisun"
          ),
          reducer: { MatchedLogic() }
        )
      )
    }
    .environment(\.colorScheme, .dark)
}
