import AnalyticsClient
import ComposableArchitecture
import FeedbackGeneratorClient
import SwiftUI

@Reducer
public struct MembershipStatusPaidContentLogic {
  public init() {}

  public struct State: Equatable {
    let expireAt: Date
  }

  public enum Action {
    case cancellationButtonTapped
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { _, action in
      switch action {
      case .cancellationButtonTapped:
        guard let url = URL(string: "https://apps.apple.com/account/subscriptions")
        else { return .none }
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
        }
      }
    }
  }
}

public struct MembershipStatusPaidContentView: View {
  let store: StoreOf<MembershipStatusPaidContentLogic>

  public init(store: StoreOf<MembershipStatusPaidContentLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      List {
        Section {
          LabeledContent {
            Text("BeMatch PRO", bundle: .module)
          } label: {
            Text("Status", bundle: .module)
          }

          LabeledContent {
            Text(viewStore.expireAt, format: .dateTime)
          } label: {
            Text("Expiration date", bundle: .module)
          }

          LabeledContent {
            Text("App Store", bundle: .module)
          } label: {
            Text("Payment Method", bundle: .module)
          }
        }

        Section {
          Button {
            store.send(.cancellationButtonTapped)
          } label: {
            LabeledContent {
              Image(systemName: "chevron.right")
            } label: {
              Text("Cancellation", bundle: .module)
                .foregroundStyle(Color.primary)
            }
          }
        }
      }
    }
  }
}

#Preview {
  NavigationStack {
    MembershipStatusPaidContentView(
      store: .init(
        initialState: MembershipStatusPaidContentLogic.State(
          expireAt: .now
        ),
        reducer: { MembershipStatusPaidContentLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
