import ConfigGlobalClient
import Dependencies
import FirebaseFirestore

extension ConfigGlobalClient: DependencyKey {
  public static let liveValue = Self.live(documentId: "global")

  public static func live(documentId: String) -> ConfigGlobalClient {
    return ConfigGlobalClient(
      config: {
        AsyncThrowingStream { continuation in
          let listener = Firestore.firestore()
            .document("/config/\(documentId)")
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
}
