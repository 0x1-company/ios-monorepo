import Apollo
import Foundation

public extension ApolloClient {
  convenience init(
    appVersion: String,
    endpoint: String,
    product: String
  ) {
    let store = ApolloStore()
    let provider = NetworkInterceptorProvider(store: store)
    let requestChainTransport = RequestChainNetworkTransport(
      interceptorProvider: provider,
      endpointURL: URL(string: endpoint)!,
      additionalHeaders: [
        "Content-Type": "application/json",
        "User-Agent": "\(product)/\(appVersion) iOS/0.0.0",
      ]
    )
    self.init(
      networkTransport: requestChainTransport,
      store: store
    )
  }
}
