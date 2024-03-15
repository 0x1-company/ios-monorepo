import AnalyticsClient
import AnalyticsKeys
import BeMatch
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct BannerLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    let banner: BeMatch.BannerCard

    public var id: String {
      banner.id
    }

    public init(banner: BeMatch.BannerCard) {
      self.banner = banner
    }
  }

  @Dependency(\.openURL) var openURL
  @Dependency(\.analytics) var analytics

  public enum Action {
    case bannerButtonTapped
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .bannerButtonTapped:
        guard let url = URL(string: state.banner.url)
        else { return .none }

        analytics.buttonClick(name: \.banner, parameters: [
          "title": state.banner.title,
          "description": state.banner.description ?? "",
          "button_title": state.banner.buttonTitle,
          "url": state.banner.url,
        ])

        return .run { _ in
          await openURL(url)
        }
      }
    }
  }
}

public struct BannerView: View {
  @Perception.Bindable var store: StoreOf<BannerLogic>

  public init(store: StoreOf<BannerLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 8) {
        Text(store.banner.title)
          .font(.system(.footnote, weight: .semibold))

        if let description = store.banner.description {
          Text(description)
            .font(.system(.caption))
        }

        Button {
          store.send(.bannerButtonTapped)
        } label: {
          Text(store.banner.buttonTitle)
            .font(.system(.caption2, weight: .semibold))
            .foregroundStyle(Color.black)
            .frame(height: 38)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(12)
        }
      }
      .padding(.all, 16)
      .frame(maxWidth: .infinity)
      .multilineTextAlignment(.center)
      .background(Color(uiColor: UIColor.secondarySystemBackground))
      .cornerRadius(12)
    }
  }
}

#Preview {
  BannerView(
    store: .init(
      initialState: BannerLogic.State(
        banner: BeMatch.BannerCard(
          _dataDict: DataDict(
            data: [
              "id": "id",
              "title": "BeMatch.の社長と話そう",
              "description": "アプリの改善策や不具合などあれば教えてください。",
              "buttonTitle": "開く",
              "url": "https://bematch.jp",
              "startAt": 10,
              "endAt": 10,
            ],
            fulfilledFragments: []
          )
        )
      ),
      reducer: { BannerLogic() }
    )
  )
  .environment(\.colorScheme, .dark)
}
