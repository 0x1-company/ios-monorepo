import API
import BannerLogic
import ComposableArchitecture
import Styleguide
import SwiftUI

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

        Button {
          store.send(.bannerButtonTapped)
        } label: {
          Text(viewStore.banner.buttonTitle)
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
        banner: API.BannerCard(
          _dataDict: DataDict(
            data: [
              "id": "id",
              "title": "TapMatchの社長と話そう",
              "description": "アプリの改善策や不具合などあれば教えてください。",
              "buttonTitle": "開く",
              "url": "https://tapmatch.jp",
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
