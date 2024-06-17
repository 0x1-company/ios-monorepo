import ComposableArchitecture
import ShortCommentSettingLogic
import Styleguide
import SwiftUI

public struct ShortCommentSettingView: View {
  @FocusState var focus: ShortCommentSettingLogic.State.Focus?
  let store: StoreOf<ShortCommentSettingLogic>

  public init(store: StoreOf<ShortCommentSettingLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 24) {
        Text("Do not write ten ten or other social media username.", bundle: .module)
          .font(.subheadline)
          .foregroundStyle(Color.secondary)

        TextEditor(text: viewStore.$shortComment)
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
          isLoading: viewStore.isActivityIndicatorVisible,
          isDisabled: viewStore.isActivityIndicatorVisible
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
      .bind(viewStore.$focus, to: $focus)
      .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
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
