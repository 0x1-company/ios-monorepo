import ComposableArchitecture
import ReportLogic
import Styleguide
import SwiftUI

public struct ReportView: View {
  @Bindable var store: StoreOf<ReportLogic>

  public init(store: StoreOf<ReportLogic>) {
    self.store = store
  }

  public var body: some View {
    NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
      List(
        [
          String(localized: "Spam", bundle: .module),
          String(localized: "Nudity or something sexualy explicit", bundle: .module),
          String(localized: "Violent or dangerous", bundle: .module),
          String(localized: "Suicide or self-harm", bundle: .module),
          String(localized: "Fake profile", bundle: .module),
          String(localized: "Other", bundle: .module),
        ],
        id: \.self
      ) { title in
        Button {
          store.send(.titleButtonTapped(title))
        } label: {
          LabeledContent {
            Image(systemName: "chevron.right")
          } label: {
            Text(title)
              .foregroundStyle(Color.primary)
          }
        }
      }
      .navigationTitle(String(localized: "Report a NewMatch", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .toolbar {
        ToolbarItem(placement: .topBarLeading) {
          Button {
            store.send(.closeButtonTapped)
          } label: {
            Image(systemName: "chevron.down")
              .bold()
              .foregroundStyle(Color.white)
              .frame(width: 44, height: 44)
          }
        }
      }
    } destination: { store in
      switch store.case {
      case let .reason(store):
        ReportReasonView(store: store)
      }
    }
    .tint(Color.white)
    .task { await store.send(.onTask).finish() }
  }
}

#Preview {
  Color.white
    .sheet(isPresented: .constant(true)) {
      ReportView(
        store: .init(
          initialState: ReportLogic.State(
            targetUserId: String()
          ),
          reducer: { ReportLogic() }
        )
      )
      .presentationDragIndicator(.visible)
      .presentationDetents([.medium, .large])
      .environment(\.colorScheme, .dark)
      .environment(\.locale, Locale(identifier: "ja-JP"))
    }
}
