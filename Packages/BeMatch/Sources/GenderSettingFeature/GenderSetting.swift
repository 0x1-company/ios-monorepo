import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import Styleguide
import SwiftUI

@Reducer
public struct GenderSettingLogic {
  public init() {}

  public struct State: Equatable {
    var selection: BeMatch.Gender?
    var genders = BeMatch.Gender.allCases
    var isActivityIndicatorVisible = false

    public init(gender: BeMatch.Gender?) {
      selection = gender
    }
  }

  public enum Action {
    case onAppear
    case genderButtonTapped(BeMatch.Gender)
    case skipButtonTapped
    case nextButtonTapped
    case updateGenderResponse(Result<BeMatch.UpdateGenderMutation.Data, Error>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case nextScreen
    }
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.updateGender) var updateGender
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onAppear:
        analytics.logScreen(screenName: "GenderSetting", of: self)
        return .none

      case let .genderButtonTapped(gender):
        state.selection = gender
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      case .nextButtonTapped:
        guard let gender = state.selection
        else { return .none }
        state.isActivityIndicatorVisible = true
        let input = BeMatch.UpdateGenderInput(
          gender: .init(gender)
        )
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.updateGenderResponse(Result {
            try await updateGender(input)
          }))
        }

      case .skipButtonTapped:
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.delegate(.nextScreen))
        }

      case .updateGenderResponse(.success):
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.nextScreen))

      case .updateGenderResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      default:
        return .none
      }
    }
  }
}

public struct GenderSettingView: View {
  let store: StoreOf<GenderSettingLogic>

  public init(store: StoreOf<GenderSettingLogic>) {
    self.store = store
  }

  func genderText(_ gender: BeMatch.Gender) -> LocalizedStringKey {
    switch gender {
    case .male:
      return "Male"
    case .female:
      return "Female"
    case .other:
      return "Non-Binary"
    }
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        Text("What's your gender?", bundle: .module)
          .font(.system(.title3, weight: .semibold))

        List(viewStore.genders, id: \.self) { gender in
          Button {
            store.send(.genderButtonTapped(gender))
          } label: {
            LabeledContent {
              if viewStore.selection == gender {
                Image(systemName: "checkmark.circle")
              }
            } label: {
              Text(genderText(gender), bundle: .module)
                .font(.system(.headline, weight: .semibold))
            }
            .frame(height: 50)
          }
        }
        .scrollDisabled(true)
        .foregroundStyle(Color.white)

        Spacer()

        VStack(spacing: 0) {
          PrimaryButton(
            String(localized: "Next", bundle: .module),
            isLoading: viewStore.isActivityIndicatorVisible,
            isDisabled: viewStore.selection == nil
          ) {
            store.send(.nextButtonTapped)
          }

          Button {
            store.send(.skipButtonTapped)
          } label: {
            Text("Skip", bundle: .module)
              .frame(height: 50)
              .foregroundStyle(Color.white)
              .font(.system(.subheadline, weight: .semibold))
          }
        }
        .padding(.horizontal, 16)
      }
      .padding(.top, 24)
      .padding(.bottom, 16)
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .onAppear { store.send(.onAppear) }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    GenderSettingView(
      store: .init(
        initialState: GenderSettingLogic.State(gender: nil),
        reducer: { GenderSettingLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
