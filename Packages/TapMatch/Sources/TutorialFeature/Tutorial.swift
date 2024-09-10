import ComposableArchitecture
import Styleguide
import SwiftUI
import TutorialLogic

public struct TutorialView: View {
  @Bindable var store: StoreOf<TutorialLogic>

  public init(store: StoreOf<TutorialLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 53) {
      Spacer()

      switch store.currentStep {
      case .first:
        Step1View()
      case .second:
        Step2View()
      case .third:
        Step3View()
      }

      if !store.isNextButtonHidden {
        VStack(spacing: 24) {
          PrimaryButton(
            String(localized: "Continue", bundle: .module)
          ) {
            store.send(.nextButtonTapped, animation: .default)
          }

          Button {
            store.send(.skipButtonTapped)
          } label: {
            Text("Skip", bundle: .module)
              .foregroundStyle(Color.godTextSecondaryDark)
              .font(.system(.body, design: .rounded, weight: .bold))
          }
        }
        .padding(.horizontal, 60)
      }

      Spacer()
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .multilineTextAlignment(.center)
    .background(Color.black.opacity(0.9))
    .task { await store.send(.onTask).finish() }
    .onTapGesture {
      if !store.isOnTapGestureDisabled {
        store.send(.nextButtonTapped, animation: .default)
      }
    }
    .overlay(alignment: .topTrailing) {
      if !store.isSkipButtonHidden {
        Button {
          store.send(.skipButtonTapped)
        } label: {
          Text("Skip", bundle: .module)
            .foregroundStyle(Color.godTextSecondaryDark)
            .font(.system(.body, design: .rounded, weight: .bold))
            .padding(.all, 24)
        }
      }
    }
    .overlay(alignment: .bottom) {
      if !store.isFinishButtonHidden {
        PrimaryButton(
          String(localized: "Get started", bundle: .module)
        ) {
          store.send(.finishButtonTapped)
        }
        .padding(.horizontal, 24)
      }
    }
  }
}

#Preview {
  TutorialView(
    store: .init(
      initialState: TutorialLogic.State(),
      reducer: { TutorialLogic() }
    )
  )
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
