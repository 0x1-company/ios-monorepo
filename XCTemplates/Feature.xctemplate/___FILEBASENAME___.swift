import ComposableArchitecture
import SwiftUI

public struct ___VARIABLE_productName:identifier___View: View {
  @Bindable var store: StoreOf<___VARIABLE_productName: identifier___Logic>

  public init(store: StoreOf<___VARIABLE_productName: identifier___Logic>) {
    self.store = store
  }

  public var body: some View {
      List {
        Spacer()
      }
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    ___VARIABLE_productName: identifier___View(
      store: .init(
        initialState: ___VARIABLE_productName: identifier___Logic.State(),
        reducer: { ___VARIABLE_productName: identifier___Logic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
