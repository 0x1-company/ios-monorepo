import ComposableArchitecture
import SettingsLogic
import SwiftUI

public struct CreationDateView: View {
  @Bindable var store: StoreOf<CreationDateLogic>

  public init(store: StoreOf<CreationDateLogic>) {
    self.store = store
  }

  public var body: some View {
    Text(store.creationDateString)
      .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  CreationDateView(
    store: .init(
      initialState: CreationDateLogic.State(
        creationDate: Date.now.addingTimeInterval(-20_000_000)
      ),
      reducer: { CreationDateLogic() }
    )
  )
}
