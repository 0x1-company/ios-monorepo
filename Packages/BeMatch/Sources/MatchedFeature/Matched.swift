import ComposableArchitecture
import MatchedLogic
import Styleguide
import SwiftUI

public struct MatchedView: View {
  @Environment(\.requestReview) var requestReview
  @Bindable var store: StoreOf<MatchedLogic>

  public init(store: StoreOf<MatchedLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 40) {
      Image(ImageResource.matched)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(height: 240)
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
