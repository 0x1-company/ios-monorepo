import API
import ComposableArchitecture
import GenderSettingLogic
import Styleguide
import SwiftUI

public struct GenderSettingView: View {
  public enum NextButtonStyle: Equatable {
    case next
    case save
  }

  let store: StoreOf<GenderSettingLogic>
  private let nextButtonStyle: NextButtonStyle
  private let canSkip: Bool

  public init(
    store: StoreOf<GenderSettingLogic>,
    nextButtonStyle: NextButtonStyle,
    canSkip: Bool
  ) {
    self.store = store
    self.nextButtonStyle = nextButtonStyle
    self.canSkip = canSkip
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        Text("Please tell us your gender.", bundle: .module)
          .font(.system(.title2, weight: .bold))

        List(viewStore.genders, id: \.self) { gender in
          Button {
            store.send(.genderButtonTapped(gender))
          } label: {
            LabeledContent {
              if viewStore.selection == gender {
                Image(systemName: "checkmark.circle")
              }
            } label: {
              Text(gender.displayValue)
                .font(.system(.headline, weight: .semibold))
            }
            .frame(height: 44)
          }
        }
        .scrollDisabled(true)
        .foregroundStyle(Color.white)

        Spacer()

        VStack(spacing: 0) {
          PrimaryButton(
            nextButtonStyle == .save
              ? String(localized: "Save", bundle: .module)
              : String(localized: "Continue", bundle: .module),
            isLoading: viewStore.isActivityIndicatorVisible,
            isDisabled: viewStore.selection == nil
          ) {
            store.send(.nextButtonTapped)
          }

          if canSkip {
            Button {
              store.send(.skipButtonTapped)
            } label: {
              Text("Skip", bundle: .module)
                .frame(height: 50)
                .foregroundStyle(Color.white)
                .font(.system(.subheadline, weight: .semibold))
            }
          }
        }
        .padding(.horizontal, 16)
      }
      .padding(.top, 32)
      .padding(.bottom, 16)
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
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
      ),
      nextButtonStyle: .next,
      canSkip: true
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
