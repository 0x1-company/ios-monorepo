import ComposableArchitecture
import ProfileLogic
import ProfileSharedFeature
import SwiftUI
import UsernameSettingFeature

public struct ProfileView: View {
  @State var translation: CGSize = .zero
  @State var scaleEffect: Double = 1.0
  @Bindable var store: StoreOf<ProfileLogic>

  public init(store: StoreOf<ProfileLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack {
      VStack(spacing: 24) {
        HStack(spacing: 0) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "chevron.down")
              .bold()
              .foregroundStyle(Color.white)
              .frame(width: 44, height: 44)
          }
          Spacer()
          if let displayName = store.currentUser?.displayName {
            Text(displayName)
              .foregroundStyle(Color.white)
              .font(.system(.callout, weight: .semibold))
          }
          Spacer()
          Spacer()
            .frame(width: 44, height: 44)
        }
        .padding(.top, 56)
        .padding(.horizontal, 16)

        if let store = store.scope(state: \.pictureSlider, action: \.pictureSlider) {
          PictureSliderView(store: store)
        } else {
          Color.black
            .aspectRatio(3 / 4, contentMode: .fill)
            .frame(width: UIScreen.main.bounds.width)
        }
        Spacer()
      }
      .background(Color.black)
      .cornerRadius(40)
      .scaleEffect(scaleEffect)
      .ignoresSafeArea()
    }
    .background(Material.ultraThin)
    .presentationBackground(Color.clear)
    .task { await store.send(.onTask).finish() }
    .gesture(
      DragGesture()
        .onEnded { _ in
          translation = .zero
          scaleEffect = 1.0
        }
        .onChanged {
          translation = $0.translation

          let startValue = 0.85
          let endValue = 1.0

          let clampedValue = min(max(translation.height, 0.0), 150.0)
          let normalizedValue = clampedValue / 100.0

          scaleEffect = startValue + (endValue - startValue) * (1.0 - normalizedValue)

          if translation.height > 150 {
            store.send(.closeButtonTapped)
          }
        }
    )
    .confirmationDialog(
      $store.scope(
        state: \.destination?.confirmationDialog,
        action: \.destination.confirmationDialog
      )
    )
    .fullScreenCover(
      item: $store.scope(state: \.destination?.editUsername, action: \.destination.editUsername)
    ) { childStore in
      NavigationStack {
        UsernameSettingView(store: childStore, nextButtonStyle: .save)
          .toolbar {
            ToolbarItem(placement: .topBarLeading) {
              Button {
                store.send(.editUsernameCloseButtonTapped)
              } label: {
                Image(systemName: "xmark")
                  .bold()
                  .foregroundStyle(Color.white)
                  .frame(width: 44, height: 44)
              }
            }
          }
      }
    }
  }
}
