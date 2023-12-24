import Dependencies
import FirebaseMessaging

extension FirebaseMessagingClient: DependencyKey {
  public static let liveValue = Self(
    delegate: {
      AsyncStream { continuation in
        let delegate = Delegate(continuation: continuation)
        Messaging.messaging().delegate = delegate
        continuation.onTermination = { _ in }
      }
    },
    setAPNSToken: { apnsToken in
      Messaging.messaging().apnsToken = apnsToken
    },
    token: { try await Messaging.messaging().token() },
    appDidReceiveMessage: { request in
      Messaging.messaging().appDidReceiveMessage(request.content.userInfo)
    }
  )
}

extension FirebaseMessagingClient {
  class Delegate: NSObject, MessagingDelegate {
    let continuation: AsyncStream<DelegateAction>.Continuation

    init(continuation: AsyncStream<DelegateAction>.Continuation) {
      self.continuation = continuation
    }

    func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
      continuation.yield(.didReceiveRegistrationToken(fcmToken: fcmToken))
    }
  }
}
