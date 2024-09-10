import ComposableArchitecture
import ShortCommentSettingLogic
import Styleguide
import SwiftUI

public struct ShortCommentSettingView: View {
  @FocusState var focus: ShortCommentSettingLogic.State.Focus?
  @Bindable var store: StoreOf<ShortCommentSettingLogic>

  public init(store: StoreOf<ShortCommentSettingLogic>) {
    self.store = store
  }

  public var body: some View {
    VStack(spacing: 24) {
      Text("Do not write Locket or other social media username.", bundle: .module)
        .font(.subheadline)
        .foregroundStyle(Color.secondary)

      TextEditor(text: $store.shortComment)
        .frame(height: 100)
        .lineLimit(1 ... 3)
        .focused($focus, equals: .shortComment)
        .padding()
        .overlay(
          RoundedRectangle(cornerRadius: 12)
            .stroke(Color.primary, lineWidth: 1.0)
        )

      PrimaryButton(
        String(localized: "Save", bundle: .module),
        isLoading: store.isActivityIndicatorVisible,
        isDisabled: store.isActivityIndicatorVisible
      ) {
        store.send(.saveButtonTapped)
      }
      .frame(maxHeight: .infinity, alignment: .bottom)
    }
    .padding(.top, 24)
    .padding(.horizontal, 16)
    .padding(.bottom, 16)
    .navigationTitle(String(localized: "Comment", bundle: .module))
    .navigationBarTitleDisplayMode(.inline)
    .task { await store.send(.onTask).finish() }
    .bind($store.focus, to: $focus)
    .alert($store.scope(state: \.alert, action: \.alert))
  }
}

#Preview {
  NavigationStack {
    ShortCommentSettingView(
      store: .init(
        initialState: ShortCommentSettingLogic.State(
          shortComment: nil
        ),
        reducer: { ShortCommentSettingLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
