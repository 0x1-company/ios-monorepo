import ActivityView
import AnalyticsClient
import AnalyticsKeys
import BeMatch
import BeMatchClient
import ComposableArchitecture
import Constants
import Styleguide
import SwiftUI

@Reducer
public struct RecommendationEmptyLogic {
  public init() {}

  public struct CompletionWithItems: Equatable {
    public let activityType: UIActivity.ActivityType?
    public let result: Bool
  }

  @ObservableState
  public struct State {
    var shareURL = Constants.appStoreForEmptyURL
    var shareText: String {
      return String(
        localized: "I found an app to increase BeReal's friends, try it.\n\(shareURL.absoluteString)",
        bundle: .module
      )
    }

    var isPresented = false
    public init() {}
  }

  public enum Action: BindableAction {
    case onTask
    case shareButtonTapped
    case currentUserResponse(Result<BeMatch.CurrentUserQuery.Data, Error>)
    case onCompletion(CompletionWithItems)
    case binding(BindingAction<State>)
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.currentUser) var currentUser

  enum Cancel {
    case currentUser
  }

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "RecommendationEmpty", of: self)
        return .run { send in
          for try await data in currentUser() {
            await send(.currentUserResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)))
        }
        .cancellable(id: Cancel.currentUser, cancelInFlight: true)

      case .shareButtonTapped:
        state.isPresented = true
        analytics.buttonClick(name: \.share)
        return .none

      case let .currentUserResponse(.success(data)):
        state.shareURL = data.currentUser.gender == .female
          ? Constants.appStoreFemaleForEmptyURL
          : Constants.appStoreForEmptyURL
        return .none

      case let .onCompletion(completion):
        state.isPresented = false
        analytics.logEvent("activity_completion", [
          "activity_type": completion.activityType?.rawValue,
          "result": completion.result,
        ])
        return .none

      default:
        return .none
      }
    }
  }
}

public struct RecommendationEmptyView: View {
  @Perception.Bindable var store: StoreOf<RecommendationEmptyLogic>

  public init(store: StoreOf<RecommendationEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 40) {
        Image(ImageResource.highAlert)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(height: 160)

        VStack(spacing: 16) {
          Text("Just a little... Too much swiping... Please help me share BeMatch... 🙏.", bundle: .module)
            .font(.system(.subheadline, weight: .semibold))
            .foregroundStyle(Color.white)
            .multilineTextAlignment(.center)

          Button {
            store.send(.shareButtonTapped)
          } label: {
            Text("Share", bundle: .module)
              .font(.system(.subheadline, weight: .semibold))
              .frame(height: 50)
              .frame(maxWidth: .infinity)
              .foregroundStyle(Color.black)
              .background(Color.white)
              .cornerRadius(16)
          }
          .buttonStyle(HoldDownButtonStyle())
        }
      }
      .padding(.horizontal, 16)
      .background(Color.black)
      .task { await store.send(.onTask).finish() }
      .sheet(isPresented: $store.isPresented) {
        ActivityView(
          activityItems: [store.shareText],
          applicationActivities: nil
        ) { activityType, result, _, _ in
          store.send(
            .onCompletion(
              RecommendationEmptyLogic.CompletionWithItems(
                activityType: activityType,
                result: result
              )
            )
          )
        }
        .presentationDetents([.medium, .large])
      }
    }
  }
}

#Preview {
  RecommendationEmptyView(
    store: .init(
      initialState: RecommendationEmptyLogic.State(),
      reducer: { RecommendationEmptyLogic() }
    )
  )
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
