import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import SwiftUI
import FeedbackGeneratorClient
import ProfileSharedFeature

@Reducer
public struct ProfileLogic {
  public init() {}

  public struct State: Equatable {
    var currentUser: BeMatch.UserInternal?
    
    var pictureSlider: PictureSliderLogic.State?
    public init() {}
  }

  public enum Action {
    case onTask
    case onAppear
    case closeButtonTapped
    case jumpBeRealButtonTapped
    case currentUserResponse(Result<BeMatch.CurrentUserQuery.Data, Error>)
    case pictureSlider(PictureSliderLogic.Action)
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.dismiss) var dismiss
  @Dependency(\.analytics) var analytics
  @Dependency(\.bematch.currentUser) var currentUser
  @Dependency(\.feedbackGenerator) var feedbackGenerator

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

      case .onAppear:
        analytics.logScreen(screenName: "Profile", of: self)
        return .none
        
      case .closeButtonTapped:
        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await dismiss()
        }
        
      case .jumpBeRealButtonTapped:
        guard let username = state.currentUser?.berealUsername
        else { return .none }
        guard let url = URL(string: "https://bere.al/\(username)")
        else { return .none }

        return .run { _ in
          await feedbackGenerator.impactOccurred()
          await openURL(url)
        }
        
      case let .currentUserResponse(.success(data)):
        let currentUser = data.currentUser.fragments.userInternal
        state.currentUser = currentUser
        state.pictureSlider = .init(images: currentUser.images.map(\.fragments.pictureSliderImage))
        return .none
        
      default:
        return .none
      }
    }
    .ifLet(\.pictureSlider, action: \.pictureSlider) {
      PictureSliderLogic()
    }
  }
}

public struct ProfileView: View {
  @State var translation: CGSize = .zero
  @State var scaleEffect: Double = 1.0
  let store: StoreOf<ProfileLogic>

  public init(store: StoreOf<ProfileLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
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
            if let username = viewStore.currentUser?.berealUsername {
              Text(username)
                .foregroundStyle(Color.white)
                .font(.system(.callout, weight: .semibold))
            }
            Spacer()
            Spacer()
              .frame(width: 44, height: 44)
          }
          .padding(.top, 56)
          .padding(.horizontal, 16)
          
          IfLetStore(
            store.scope(state: \.pictureSlider, action: \.pictureSlider),
            then: PictureSliderView.init(store:),
            else: {
              Color.black
                .aspectRatio(3 / 4, contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
            }
          )
          
          if let username = viewStore.currentUser?.berealUsername {
            Button {
              store.send(.jumpBeRealButtonTapped)
            } label: {
              Text("🔗 BeRe.al/\(username)")
                .font(.system(.caption))
                .foregroundStyle(Color.primary)
            }
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
      .onAppear { store.send(.onAppear) }
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
    }
  }
}
