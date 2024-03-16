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

  @ObservableState
  public struct State: Equatable {
    var currentStep = Step.first

    var isSkipButtonHidden: Bool {
      [TutorialLogic.Step.first, .third].contains(currentStep)
    }

    var isOnTapGestureDisabled: Bool {
      currentStep == .third
    }

    var isNextButtonHidden: Bool {
      currentStep != .first
    }

    var isFinishButtonHidden: Bool {
      currentStep != .third
    }

    public init() {}
  }

  public enum Action {
    case onTask
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
  @Perception.Bindable var store: StoreOf<TutorialLogic>

  public init(store: StoreOf<TutorialLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
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
