import ComposableArchitecture
import Constants
import Styleguide
import SwiftUI

@Reducer
public struct MaintenanceLogic {
  public init() {}

  @ObservableState
  public struct State {
    public init() {}
  }

  public enum Action {}

  public var body: some Reducer<State, Action> {
    EmptyReducer()
  }
}

public struct MaintenanceView: View {
  @Perception.Bindable var store: StoreOf<MaintenanceLogic>

  public init(store: StoreOf<MaintenanceLogic>) {
    self.store = store
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 80) {
        VStack(spacing: 24) {
          Text("Under Maintenance", bundle: .module)
            .font(.system(.title, weight: .semibold))

          Text("Please wait for a while until service resumes.", bundle: .module)
            .font(.system(.body, weight: .semibold))
        }

        Link(destination: Constants.contactUsURL) {
          Text("Contact us", bundle: .module)
            .font(.system(.subheadline, weight: .semibold))
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color.black)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
      }
      .padding(.horizontal, 24)
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .background(Color.black)
      .foregroundStyle(Color.white)
      .multilineTextAlignment(.center)
    }
  }
}

#Preview {
  MaintenanceView(
    store: .init(
      initialState: MaintenanceLogic.State(),
      reducer: { MaintenanceLogic() }
    )
  )
}
