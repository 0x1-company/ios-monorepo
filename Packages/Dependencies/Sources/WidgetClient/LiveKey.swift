import Dependencies
import WidgetKit

extension WidgetClient: DependencyKey {
  public static let liveValue = Self(
    reloadAllTimelines: { WidgetCenter.shared.reloadAllTimelines() },
    currentConfigurations: {
      try await withCheckedThrowingContinuation { continuation in
        WidgetCenter.shared.getCurrentConfigurations { result in
          switch result {
          case let .success(success):
            continuation.resume(returning: success)
          case let .failure(failure):
            continuation.resume(throwing: failure)
          }
        }
      }
    }
  )
}
