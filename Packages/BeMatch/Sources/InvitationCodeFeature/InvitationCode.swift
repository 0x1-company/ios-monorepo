import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import Styleguide
import SwiftUI

@Reducer
public struct InvitationCodeLogic {
  public init() {}

  public struct State: Equatable {
    var code = ""

    public init() {}
  }

  public enum Action {
    case onTask
    case shareInvitationCodeButtonTapped
    case invitationCodeResponse(Result<BeMatch.InvitationCodeQuery.Data, Error>)
  }

  @Dependency(\.bematch) var bematch
  @Dependency(\.analytics) var analytics

  enum Cancel {
    case invitationCode
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "InvitationCode", of: self)
        return .run { send in
          for try await data in bematch.invitationCode() {
            await send(.invitationCodeResponse(.success(data)))
          }
        } catch: { error, send in
          await send(.invitationCodeResponse(.failure(error)))
        }
        .cancellable(id: Cancel.invitationCode, cancelInFlight: true)

      case .shareInvitationCodeButtonTapped:
        return .none

      case let .invitationCodeResponse(.success(data)):
        state.code = data.invitationCode.code
        return .none

      default:
        return .none
      }
    }
  }
}

public struct InvitationCodeView: View {
  let store: StoreOf<InvitationCodeLogic>

  public init(store: StoreOf<InvitationCodeLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack(spacing: 16) {
        VStack(spacing: 16) {
          Image(ImageResource.inviteTicket)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .overlay(alignment: .center) {
              Text(viewStore.code)
                .foregroundStyle(Color(0xFFFF_CC00))
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .offset(x: -35, y: 8)
            }
        }
        .padding(.all, 16)
        .background(Color(uiColor: UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal, 16)
      }
      .padding(.vertical, 24)
      .background()
      .navigationTitle(String(localized: "Invitation Code", bundle: .module))
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
    }
  }
}

#Preview {
  NavigationStack {
    InvitationCodeView(
      store: .init(
        initialState: InvitationCodeLogic.State(),
        reducer: { InvitationCodeLogic() }
      )
    )
  }
  .environment(\.colorScheme, .dark)
}
