import CoreMotion
import Dependencies
import DependenciesMacros

@DependencyClient
public struct MotionManagerClient: Sendable {
  public var isAccelerometerAvailable: @Sendable () -> Bool = { false }
  public var accelerometerUpdateInterval: @Sendable (TimeInterval) -> Void
  public var stopAccelerometerUpdates: @Sendable () -> Void
  public var startAccelerometerUpdates: @Sendable (OperationQueue) -> AsyncStream<Result<CMAccelerometerData, Error>> = { _ in .finished }
}
