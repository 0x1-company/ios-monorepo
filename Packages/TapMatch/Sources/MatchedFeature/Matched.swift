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
            String(localized: "Add TapNow", bundle: .module)
          ) {
            store.send(.addExternalProductButtonTapped)
          }

          Text("🔗 \(viewStore.displayTargetUserInfo)", bundle: .module)
            .foregroundStyle(Color.white)
            .font(.system(.caption, weight: .semibold))
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
