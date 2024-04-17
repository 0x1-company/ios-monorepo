import CategoryListLogic
import ComposableArchitecture
import SwiftUI

public struct CategorySectionView: View {
  let store: StoreOf<CategorySectionLogic>

  public init(store: StoreOf<CategorySectionLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 8) {
        Text(viewStore.userCategory.title)
          .font(.system(.callout, weight: .semibold))
          .padding(.horizontal, 16)

        ScrollView(.horizontal, showsIndicators: false) {
          LazyHStack(spacing: 12) {
            ForEachStore(
              store.scope(state: \.rows, action: \.rows),
              content: CategoryRowView.init(store:)
            )
          }
          .padding(.horizontal, 16)
        }
      }
    }
  }
}
