import CachedAsyncImage
import ComposableArchitecture
import MatchedLogic
import Styleguide
import SwiftUI

public struct MatchedView: View {
  @Environment(\.displayScale) var displayScale
  @Environment(\.requestReview) var requestReview
  let store: StoreOf<MatchedLogic>

  public init(store: StoreOf<MatchedLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        VStack(spacing: 16) {
          Image(ImageResource.matched)
            .resizable()
            .aspectRatio(contentMode: .fit)

          HStack(spacing: -12) {
            ForEach(
              [viewStore.currentUserImageUrl, viewStore.targetUserImageUrl],
              id: \.self
            ) { imageUrl in
              CachedAsyncImage(
                url: imageUrl,
                urlCache: URLCache.shared,
                scale: displayScale,
                content: { image in
                  image
                    .resizable()
                },
                placeholder: {
                  Color.clear
                    .overlay {
                      ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .tint(Color.white)
                    }
                }
              )
              .aspectRatio(1, contentMode: .fill)
              .clipShape(Circle())
              .frame(width: 128, height: 128)
              .overlay(
                RoundedRectangle(cornerRadius: 128 / 2)
                  .stroke(Color(uiColor: UIColor.opaqueSeparator), lineWidth: 2.0)
              )
            }
          }

          Text("You matched with \(viewStore.targetUserDisplayName)", bundle: .module)
            .foregroundStyle(Color.white)
            .font(.system(.headline, weight: .semibold))
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 37)

        VStack(spacing: 12) {
          PrimaryButton(
            String(localized: "Copy tenten’s PIN", bundle: .module)
          ) {
            store.send(.addExternalProductButtonTapped)
          }

          Text("🧷 \(viewStore.displayTargetUserInfo)", bundle: .module)
            .foregroundStyle(Color.white)
            .font(.system(.caption, weight: .semibold))
        }
      }
      .padding(.horizontal, 16)
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
            .font(.system(size: 12, weight: .regular))
            .frame(width: 36, height: 36)
            .foregroundStyle(Color.white)
            .background(Color(uiColor: UIColor.quaternarySystemFill))
            .clipShape(Circle())
        }
        .padding(.horizontal, 12)
      }
      .background(
        LinearGradient(
          colors: [
            Color(0xFF30_D158),
            Color(0xFFFF_D60A),
            Color(0xFFFF_2E00),
            Color(0xFF00_0000),
          ],
          startPoint: .top,
          endPoint: .bottom
        )
      )
      .alert(
        store: store.scope(state: \.$destination.alert, action: \.destination.alert)
      )
    }
  }
}

#Preview {
  NavigationStack {
    MatchedView(
      store: .init(
        initialState: MatchedLogic.State(
          targetUserId: "",
          displayName: "tomokisun",
          tentenPinCode: "du9v5pq",
          externalProductURL: URL(string: "https://bere.al/tomokisun")!
        ),
        reducer: MatchedLogic.init,
        withDependencies: {
          $0.environment = .live(
            brand: .picmatch,
            instagramUsername: "",
            appId: "",
            appStoreForEmptyURL: .applicationDirectory,
            docsURL: .applicationDirectory,
            howToMovieURL: .applicationDirectory
          )
        }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
