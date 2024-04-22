import Dependencies
import FacebookCore

extension FacebookClient: DependencyKey {
  public static let liveValue = Self(
    didFinishLaunchingWithOptions: { application, didFinishLaunchingWithOptions in
      ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: didFinishLaunchingWithOptions)
    },
    open: { application, open, sourceApplication, annotation in
      ApplicationDelegate.shared.application(application, open: open, sourceApplication: sourceApplication, annotation: annotation)
    }
  )
}
