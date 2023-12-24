import BeMatch
import CachedAsyncImage
import ComposableArchitecture
import FeedbackGeneratorClient
import ProfileExternalFeature
import Styleguide
import SwiftUI

@Reducer
public struct MatchGridLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    public var id: String {
      match.id
    }

    let match: BeMatch.MatchGrid

    var createdAt: Date {
      guard let timeInterval = TimeInterval(match.createdAt)
      else { return .now }
      return Date(timeIntervalSince1970: timeInterval / 1000.0)
    }

    @PresentationState var profileExternal: ProfileExternalLogic.State?

    public init(match: BeMatch.MatchGrid) {
      self.match = match
    }
  }

  public enum Action {
    case matchButtonTapped
    case profileExternal(PresentationAction<ProfileExternalLogic.Action>)
  }

  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .matchButtonTapped:
        state.profileExternal = .init(match: state.match)
        return .run { _ in
          await feedbackGenerator.impactOccurred()
        }

      default:
        return .none
      }
    }
    .ifLet(\.$profileExternal, action: \.profileExternal) {
      ProfileExternalLogic()
    }
  }
}

public struct MatchGridView: View {
  @Environment(\.displayScale) var displayScale
  let store: StoreOf<MatchGridLogic>

  public init(store: StoreOf<MatchGridLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      Button {
        store.send(.matchButtonTapped)
      } label: {
        VStack(spacing: 20) {
          CachedAsyncImage(
            url: URL(string: viewStore.match.targetUser.images.first?.imageUrl ?? ""),
            urlCache: .shared,
            scale: displayScale,
            content: { image in
              image
                .resizable()
                .aspectRatio(3 / 4, contentMode: .fill)
            },
            placeholder: {
              ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .tint(Color.white)
                .aspectRatio(3 / 4, contentMode: .fill)
                .background()
            }
          )
          .cornerRadius(6)
          .overlay(alignment: .bottom) {
            if !viewStore.match.isRead {
              Color.pink
                .frame(width: 16, height: 16)
                .clipShape(Circle())
                .overlay {
                  RoundedRectangle(cornerRadius: 16 / 2)
                    .stroke(Color.white, lineWidth: 2)
                }
                .offset(y: 10)
            }
          }

          VStack(spacing: 8) {
            Text(viewStore.match.targetUser.berealUsername)
              .font(.system(.subheadline, weight: .semibold))
              .frame(maxWidth: .infinity, alignment: .leading)

            Text(viewStore.createdAt, format: Date.FormatStyle(date: .numeric))
              .foregroundStyle(Color.gray)
              .font(.system(.caption2, weight: .semibold))
              .frame(maxWidth: .infinity, alignment: .leading)
          }
        }
      }
      .buttonStyle(HoldDownButtonStyle())
      .fullScreenCover(
        store: store.scope(state: \.$profileExternal, action: \.profileExternal)
      ) { store in
        ProfileExternalView(store: store)
      }
    }
  }
}
