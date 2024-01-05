import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct TutorialLogic {
  public init() {}

  public enum Step: Int {
    case first, second, third
  }

  public struct State: Equatable {
    var currentStep = Step.first
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case nextButtonTapped
    case skipButtonTapped
    case finishButtonTapped
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case finish
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .none

      case .onAppear:
        analytics.logScreen(screenName: "Tutorial", of: self)
        return .none

      case .nextButtonTapped:
        guard let nextStep = Step(rawValue: state.currentStep.rawValue + 1)
        else { return .none }
        state.currentStep = nextStep
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .skipButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.finish), animation: .default)
        }

      case .finishButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.finish), animation: .default)
        }

      case .delegate:
        return .none
      }
    }
  }
}

public struct TutorialView: View {
  let store: StoreOf<TutorialLogic>

  public init(store: StoreOf<TutorialLogic>) {
    self.store = store
  }

  struct ViewState: Equatable {
    let currentStep: TutorialLogic.Step
    let isSkipButtonHidden: Bool
    let isOnTapGestureDisabled: Bool
    let isNextButtonHidden: Bool
    let isFinishButtonHidden: Bool

    init(state: TutorialLogic.State) {
      currentStep = state.currentStep
      isSkipButtonHidden = [TutorialLogic.Step.first, .third].contains(state.currentStep)
      isOnTapGestureDisabled = state.currentStep == .third
      isNextButtonHidden = state.currentStep != .first
      isFinishButtonHidden = state.currentStep != .third
    }
  }

  public var body: some View {
    WithViewStore(store, observe: ViewState.init) { viewStore in
      VStack(spacing: 53) {
        Spacer()

        switch viewStore.currentStep {
        case .first:
          Step1View()
        case .second:
          Step2View()
        case .third:
          Step3View()
        }

        if !viewStore.isNextButtonHidden {
          VStack(spacing: 24) {
            PrimaryButton(
              String(localized: "Next", bundle: .module)
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
      .onAppear { store.send(.onAppear) }
      .onTapGesture {
        if !viewStore.isOnTapGestureDisabled {
          store.send(.nextButtonTapped, animation: .default)
        }
      }
      .overlay(alignment: .topTrailing) {
        if !viewStore.isSkipButtonHidden {
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
        if !viewStore.isFinishButtonHidden {
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
