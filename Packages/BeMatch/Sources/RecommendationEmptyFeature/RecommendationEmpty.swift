import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import Constants
import Styleguide
import SwiftUI

@Reducer
public struct RecommendationEmptyLogic {
  public init() {}

  public struct State: Equatable {
    var sharedURL = Constants.appStoreForEmptyURL
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case currentUserResponse(Result<BeMatch.CurrentUserQuery.Data, Error>)
  }

  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.currentUser) var currentUser

  enum Cancel {
    case currentUser
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        return .run { send in
          for try await data in currentUser() {
            await send(.currentUserResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.currentUserResponse(.failure(error)))
        }
        .cancellable(id: Cancel.currentUser, cancelInFlight: true)

      case .onAppear:
        analytics.logScreen(screenName: "RecommendationEmpty", of: self)
        return .none

      case let .currentUserResponse(.success(data)):
        state.sharedURL = data.currentUser.gender == .female
          ? Constants.appStoreFemaleForEmptyURL
          : Constants.appStoreForEmptyURL
        return .none

      case .currentUserResponse(.failure):
        return .none
      }
    }
  }
}

public struct RecommendationEmptyView: View {
  let store: StoreOf<RecommendationEmptyLogic>

  public init(store: StoreOf<RecommendationEmptyLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
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

          ShareLink(item: viewStore.sharedURL) {
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
      .onAppear { store.send(.onAppear) }
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
