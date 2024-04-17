import CoreMotion
import Dependencies

extension MotionManagerClient: DependencyKey {
  public static let liveValue: Self = {
    let motionManager = CMMotionManager()

    return Self(
      isAccelerometerAvailable: { motionManager.isAccelerometerActive },
      accelerometerUpdateInterval: { motionManager.accelerometerUpdateInterval = $0 },
      stopAccelerometerUpdates: { motionManager.stopAccelerometerUpdates() },
      startAccelerometerUpdates: { queue in
        AsyncStream { continuation in
          motionManager.startAccelerometerUpdates(to: queue) { accelerometerData, error in
            if let error {
              continuation.yield(.failure(error))
            }
            if let accelerometerData {
              continuation.yield(.success(accelerometerData))
            }
          }
        }
      }
    )
  }()
}
