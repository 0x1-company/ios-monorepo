import ComposableArchitecture
import CoreMotion

private let GRAVITY_THRESHOLD = 0.2

@Reducer
public struct AccelerometerLogic {
  public init() {}

  public struct State: Equatable {
    let motionManager = CMMotionManager()
    var zeroGravityStartTime: Date?
    var zeroGravityEndTime: Date?

    public init() {}
  }

  public enum Action {
    case startAccelerometerUpdates
    case stopAccelerometerUpdates
    case accelerometerUpdates(Result<CMAccelerometerData, Error>)
  }

  @Dependency(\.date.now) var now

  enum Cancel {
    case accelerometerUpdates
  }

  public var body: some Reducer<State, Action> {
    Reduce<State, Action> { state, action in
      switch action {
      case .startAccelerometerUpdates:
        let motionManager = state.motionManager
        motionManager.accelerometerUpdateInterval = 0.01

        return .run { send in
          for await result in startAccelerometerUpdates(motionManager) {
            await send(.accelerometerUpdates(result))
          }
        }
        .cancellable(id: Cancel.accelerometerUpdates, cancelInFlight: true)

      case .stopAccelerometerUpdates:
        state.motionManager.stopAccelerometerUpdates()
        return .none

      case let .accelerometerUpdates(.success(data)):
        let acceleration = data.acceleration
        let accelerationMagnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)

        if accelerationMagnitude < GRAVITY_THRESHOLD {
          guard state.zeroGravityStartTime == nil else { return .none }
          state.zeroGravityStartTime = now
          return .none
        } else {
          guard state.zeroGravityStartTime != nil else { return .none }
          state.zeroGravityEndTime = now
          state.motionManager.stopAccelerometerUpdates()
          return .none
        }

      default:
        return .none
      }
    }
  }

  func startAccelerometerUpdates(_ motionManager: CMMotionManager) -> AsyncStream<Result<CMAccelerometerData, Error>> {
    AsyncStream { continuation in
      motionManager.startAccelerometerUpdates(to: .main) { accelerometerData, error in
        if let error {
          continuation.yield(.failure(error))
        }
        if let accelerometerData {
          continuation.yield(.success(accelerometerData))
        }
      }
    }
  }
}
