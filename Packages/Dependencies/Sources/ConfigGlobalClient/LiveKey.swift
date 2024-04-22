import Dependencies
import FirebaseFirestore
import FirebaseFirestoreSwift

extension ConfigGlobalClient: DependencyKey {
  public static let liveValue = Self(
    config: {
      AsyncThrowingStream { continuation in
        let listener = Firestore.firestore()
          .document("/config/global")
          .addSnapshotListener { documentSnapshot, error in
            if let error {
              continuation.finish(throwing: error)
            }
            if let documentSnapshot {
              do {
                try continuation.yield(
                  documentSnapshot.data(as: Config.self)
                )
              } catch {
                continuation.finish(throwing: error)
              }
            }
          }
        continuation.onTermination = { @Sendable _ in
          listener.remove()
        }
      }
    }
  )
}
