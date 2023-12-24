import BeMatch
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct BannerLogic {
  public init() {}

  public struct State: Equatable, Identifiable {
    let banner: BeMatch.BannerCard

    public var id: String {
      banner.id
    }

    public init(banner: BeMatch.BannerCard) {
      self.banner = banner
    }
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

public struct BannerView: View {
  let store: StoreOf<BannerLogic>

  public init(store: StoreOf<BannerLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 8) {
        Text(viewStore.banner.title)
          .font(.system(.footnote, weight: .semibold))

        if let description = viewStore.banner.description {
          Text(description)
            .font(.system(.caption))
        }

        if let url = URL(string: viewStore.banner.url) {
          Link(destination: url) {
            Text("Open", bundle: .module)
              .font(.system(.caption2, weight: .semibold))
              .foregroundStyle(Color.black)
              .frame(height: 38)
              .frame(maxWidth: .infinity)
              .background(Color.white)
              .cornerRadius(12)
          }
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
