import Dependencies
import XCTestDynamicOverlay

public extension DependencyValues {
  var feedbackGenerator: FeedbackGeneratorClient {
    get { self[FeedbackGeneratorClient.self] }
    set { self[FeedbackGeneratorClient.self] = newValue }
  }
}

extension FeedbackGeneratorClient: TestDependencyKey {
  public static let testValue = Self(
    prepare: unimplemented("\(Self.self).prepare"),
    impactOccurred: unimplemented("\(Self.self).mediumImpact"),
    notificationOccurred: unimplemented("\(Self.self).notificationOccurred"),
    play: unimplemented("\(Self.self).play")
  )
}
