import ComposableArchitecture
import DirectMessageFeature
import ProfileExplorerLogic
import ReportFeature
import SwiftUI

public struct ProfileExplorerView: View {
  @FocusState var focus: Bool
  let store: StoreOf<ProfileExplorerLogic>

  public init(store: StoreOf<ProfileExplorerLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 0) {
        TabView(selection: viewStore.$currentTab) {
          DirectMessageView(store: store.scope(state: \.directMessage, action: \.directMessage))
            .tag(ProfileExplorerLogic.Tab.message)

          ProfileExplorerPreviewView(store: store.scope(state: \.preview, action: \.preview))
            .tag(ProfileExplorerLogic.Tab.profile)
        }
        .onTapGesture {
          focus = false
        }

        HStack(spacing: 8) {
          TextField(
            text: viewStore.$text,
            axis: .vertical
          ) {
            Text("Message", bundle: .module)
          }
          .focused($focus)
          .lineLimit(1 ... 10)
          .padding(.vertical, 8)
          .padding(.horizontal, 16)
          .tint(Color.white)
          .background(Color(uiColor: UIColor.tertiarySystemBackground))
          .clipShape(RoundedRectangle(cornerRadius: 26))

          Button {
            store.send(.sendButtonTapped, animation: .default)
          } label: {
            Image(systemName: "paperplane.fill")
              .foregroundStyle(Color.primary)
          }
          .disabled(viewStore.isDisabled)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
      }
      .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar(.hidden, for: .tabBar)
      .toolbar {
        ToolbarItem(placement: .principal) {
          Button {
            store.send(.principalButtonTapped, animation: .default)
          } label: {
            Text(viewStore.displayName)
              .foregroundStyle(Color.primary)
              .font(.system(.callout, design: .rounded, weight: .semibold))
          }
        }

        ToolbarItem(placement: .topBarTrailing) {
          Menu {
            Button(role: .destructive) {
              store.send(.unmatchButtonTapped)
            } label: {
              Label {
                Text("Unmatch", bundle: .module)
              } icon: {
                Image(systemName: "trash")
              }
            }

            Button {
              store.send(.reportButtonTapped)
            } label: {
              Label {
                Text("Report", bundle: .module)
              } icon: {
                Image(systemName: "exclamationmark.triangle")
              }
            }

            Button {
              store.send(.blockButtonTapped)
            } label: {
              Text("Block", bundle: .module)
            }
          } label: {
            Image(systemName: "ellipsis")
              .bold()
              .foregroundStyle(Color.white)
              .frame(width: 44, height: 44)
          }
        }
      }
      .sheet(
        store: store.scope(state: \.$destination.report, action: \.destination.report),
        content: ReportView.init(store:)
      )
      .confirmationDialog(
        store: store.scope(
          state: \.$destination.confirmationDialog,
          action: \.destination.confirmationDialog
        )
      )
    }
  }
}

#Preview {
  NavigationStack {
    ProfileExplorerView(
      store: .init(
        initialState: ProfileExplorerLogic.State(
          displayName: "tomokisun",
          targetUserId: "id"
        ),
        reducer: { ProfileExplorerLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
