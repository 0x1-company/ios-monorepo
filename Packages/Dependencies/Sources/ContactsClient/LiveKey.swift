import Contacts
import Dependencies

extension ContactsClient: DependencyKey {
  public static let liveValue: Self = {
    let store = CNContactStore()
    return Self(
      authorizationStatus: CNContactStore.authorizationStatus(for:),
      requestAccess: store.requestAccess(for:),
      enumerateContacts: { request in
        AsyncThrowingStream { continuation in
          do {
            try store.enumerateContacts(with: request) { contact, pointer in
              continuation.yield((contact, pointer))
            }
            continuation.finish()
          } catch {
            continuation.finish(throwing: error)
          }
        }
      },
      unifiedContacts: { predicate, keysToFetch in
        try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
      }
    )
  }()
}
