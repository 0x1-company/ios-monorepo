import Dependencies
import FirebaseAuth

extension FirebaseAuthClient: DependencyKey {
  public static let liveValue = Self(
    currentUser: { Auth.auth().currentUser },
    addStateDidChangeListener: {
      AsyncStream { continuation in
        Auth.auth().addStateDidChangeListener { _, user in
          continuation.yield(user)
        }
      }
    },
    languageCode: { Auth.auth().languageCode = $0 },
    signOut: { try Auth.auth().signOut() },
    canHandle: { Auth.auth().canHandle($0) },
    canHandleNotification: { Auth.auth().canHandleNotification($0) },
    setAPNSToken: { Auth.auth().setAPNSToken($0, type: $1) },
    verifyPhoneNumber: { phoneNumber in
      assert(phoneNumber.first == "+", "Need to PhoneNumberClient.parseFormat")
      return try await withCheckedThrowingContinuation { continuation in
        PhoneAuthProvider.provider()
          .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
            if let error {
              continuation.resume(throwing: error)
            } else {
              continuation.resume(returning: verificationID)
            }
          }
      }
    },
    credential: { PhoneAuthProvider.provider().credential(withVerificationID: $0, verificationCode: $1) },
    signIn: { credential in
      try await withCheckedThrowingContinuation { continuation in
        Auth.auth().signIn(with: credential) { result, error in
          if let error {
            continuation.resume(throwing: error)
          } else {
            continuation.resume(returning: result)
          }
        }
      }
    },
    signInAnonymously: { try await Auth.auth().signInAnonymously() },
    currentUserIdToken: {
      guard let currentUser = Auth.auth().currentUser else { return nil }
      return try await currentUser.getIDToken()
    }
  )
}
