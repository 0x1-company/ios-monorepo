import AnalyticsClient
import AnalyticsKeys
import ComposableArchitecture
import FeedbackGeneratorClient
import StoreKit
import Styleguide
import SwiftUI

@Reducer
public struct MatchedLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    let username: String
    public init(username: String) {
      self.username = username
    }
  }

  public enum Action: Equatable {
    case onTask
    case addBeRealButtonTapped
    case closeButtonTapped
  }

  @Dependency(\.dismiss) var dismiss
  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "Matched", of: self)
        return .none

      case .addBeRealButtonTapped:
        guard let url = URL(string: "https://bere.al/\(state.username)")
        else { return .none }

        analytics.buttonClick(name: \.addBeReal, parameters: [
          "url": url.absoluteString,
        ])

        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
          await dismiss()
        }

      case .closeButtonTapped:
        return .run { _ in
          await dismiss()
        }
      }
    }
  }
}

public struct MatchedView: View {
  @Environment(\.requestReview) var requestReview
  @Perception.Bindable var store: StoreOf<MatchedLogic>

  public init(store: StoreOf<MatchedLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
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

          Text("🔗 BeRe.al/\(store.username)", bundle: .module)
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
