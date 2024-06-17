import ComposableArchitecture
import ReportLogic
import Styleguide
import SwiftUI

public struct ReportReasonView: View {
  @FocusState var focus: ReportReasonLogic.State.Field?
  let store: StoreOf<ReportReasonLogic>

  public init(store: StoreOf<ReportReasonLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(alignment: .leading, spacing: 16) {
        VStack(alignment: .leading, spacing: 0) {
          Text("Your report is confidential.", bundle: .module)

          Text("If you or someone you know is in immediate danger, contact local low enforcement or your local emergency services immediately.", bundle: .module)
            .layoutPriority(1)
            .frame(minHeight: 50)
        }
        .font(.system(.footnote, design: .rounded))

        VStack(alignment: .leading, spacing: 8) {
          TextEditor(text: viewStore.$text)
            .frame(height: 140)
            .lineLimit(1 ... 10)
            .focused($focus, equals: .text)
            .overlay(
              RoundedRectangle(cornerRadius: 12)
                .stroke(Color.primary, lineWidth: 1.0)
            )

          Text("Minimum of 10 characters required.", bundle: .module)
            .foregroundStyle(Color.secondary)
            .font(.caption, design: .rounded)
        }

        Spacer()

        PrimaryButton(
          String(localized: "Send", bundle: .module),
          isLoading: viewStore.isActivityIndicatorVisible,
          isDisabled: viewStore.isDisabled
        ) {
          store.send(.sendButtonTapped)
        }
      }
      .padding(.vertical, 24)
      .padding(.horizontal, 16)
      .formStyle(ColumnsFormStyle())
      .navigationTitle(Text("Report a TenMatch", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .bind(viewStore.$focus, to: $focus)
      .alert(store: store.scope(state: \.$alert, action: \.alert))
    }
  }
}

#Preview {
  NavigationStack {
    ReportReasonView(
      store: .init(
        initialState: ReportReasonLogic.State(
          title: String(localized: "Spam", bundle: .module),
          kind: .user(targetUserId: "")
        ),
        reducer: { ReportReasonLogic() }
      )
    )
  }
  .presentationDragIndicator(.visible)
  .presentationDetents([.medium, .large])
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
