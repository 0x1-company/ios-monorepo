import CoreHaptics
import Dependencies
import UIKit

extension FeedbackGeneratorClient: DependencyKey {
  public static let liveValue = {
    let generator = UISelectionFeedbackGenerator()
    let impact = UIImpactFeedbackGenerator(style: .medium)
    let notification = UINotificationFeedbackGenerator()
    let engine = try? CHHapticEngine()
    try? engine?.start()

    return Self(
      prepare: { await generator.prepare() },
      impactOccurred: { await impact.impactOccurred() },
      notificationOccurred: { await notification.notificationOccurred($0) },
      play: { events in
        let pattern = try CHHapticPattern(events: events, parameters: [])
        guard let player = try engine?.makePlayer(with: pattern) else { return }
        try player.start(atTime: 0)
      }
    )
  }()
}
