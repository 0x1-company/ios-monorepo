import Apollo
import ApolloAPI
import FirebaseAuth
import Foundation

class FirebaseTokenInterceptor: ApolloInterceptor {
  var id: String = UUID().uuidString

  func interceptAsync<Operation: GraphQLOperation>(
    chain: RequestChain,
    request: HTTPRequest<Operation>,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
  ) {
    guard let currentUser = Auth.auth().currentUser else {
      addTokenAndProceed(
        "",
        to: request,
        chain: chain,
        response: response,
        completion: completion
      )
      return
    }
    currentUser.getIDToken(completion: { [weak self] token, error in
      if let error {
        print(error.localizedDescription)
      }
      self?.addTokenAndProceed(
        token ?? "",
        to: request,
        chain: chain,
        response: response,
        completion: completion
      )
    })
  }

  private func addTokenAndProceed<Operation: GraphQLOperation>(
    _ token: String,
    to request: HTTPRequest<Operation>,
    chain: RequestChain,
    response: HTTPResponse<Operation>?,
    completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
  ) {
    request.addHeader(name: "Authorization", value: "Bearer \(token)")
    chain.proceedAsync(
      request: request,
      response: response,
      interceptor: self,
      completion: completion
    )
  }
}
