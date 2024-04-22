import CoreHaptics
import UIKit

public struct FeedbackGeneratorClient {
  public var prepare: @Sendable () async -> Void
  public var impactOccurred: @Sendable () async -> Void
  public var notificationOccurred: @Sendable (UINotificationFeedbackGenerator.FeedbackType) async -> Void
  public var play: @Sendable ([CHHapticEvent]) throws -> Void
}
