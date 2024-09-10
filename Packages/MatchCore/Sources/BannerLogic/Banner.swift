import AnalyticsClient
import AnalyticsKeys
import API
import ComposableArchitecture
import SwiftUI

@Reducer
public struct BannerLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable, Identifiable {
    public let banner: API.BannerCard

    public var id: String {
      banner.id
    }

    public init(banner: API.BannerCard) {
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
