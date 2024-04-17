import Apollo
import ApolloAPI
import Foundation

public extension ApolloClient {
  func watch<Query: GraphQLQuery>(
    query: Query,
    cachePolicy: CachePolicy = .returnCacheDataAndFetch,
    contextIdentifier _: UUID? = nil,
    callbackQueue: DispatchQueue = .main
  ) -> AsyncThrowingStream<Query.Data, Error> {
    AsyncThrowingStream { continuation in
      let watcher = watch(
        query: query,
        cachePolicy: cachePolicy,
        callbackQueue: callbackQueue
      ) { result in
        switch result {
        case let .success(response):
          if let data = response.data {
            continuation.yield(data)
          } else if let error = response.errors?.last {
            continuation.yield(with: .failure(ServerError(error: error)))
          } else {
            continuation.finish(throwing: nil)
          }
        case let .failure(error):
          continuation.finish(throwing: error)
        }
      }
      continuation.onTermination = { @Sendable _ in
        watcher.cancel()
      }
    }
  }

  func perform<Mutation: GraphQLMutation>(
    mutation: Mutation,
    publishResultToStore: Bool = true,
    queue: DispatchQueue = .main
  ) async throws -> Mutation.Data {
    try await withCheckedThrowingContinuation { continuation in
      perform(
        mutation: mutation,
        publishResultToStore: publishResultToStore,
        queue: queue,
        resultHandler: { result in
          switch result {
          case let .success(response):
            if let data = response.data {
              continuation.resume(returning: data)
            }
            if let error = response.errors?.last {
              continuation.resume(throwing: ServerError(error: error))
            }
          case let .failure(error):
            continuation.resume(throwing: error)
          }
        }
      )
    }
  }
}

public struct ServerError: Error {
  public let message: String
  public let extensions: [String: Any]
  public var code: ServerErrorCode? {
    guard let code = extensions["code"] as? String
    else { return nil }
    return ServerErrorCode(rawValue: code)
  }

  public init(
    message: String,
    extensions: [String: Any]
  ) {
    self.message = message
    self.extensions = extensions
  }

  public enum ServerErrorCode: String {
    case badUserInput = "BAD_USER_INPUT"
    case forbidden = "FORBIDDEN"
    case unauthenticated = "UNAUTHENTICATED"
    case `internal` = "INTERNAL_SERVER_ERROR"
    case notInGodMode = "NOT_IN_GOD_MODE"
    case noRevealPermission = "NO_REVEAL_PERMISSION"
  }
}

public extension ServerError {
  init(error: GraphQLError) {
    self.init(
      message: error.message ?? "",
      extensions: error.extensions ?? [:]
    )
  }
}
