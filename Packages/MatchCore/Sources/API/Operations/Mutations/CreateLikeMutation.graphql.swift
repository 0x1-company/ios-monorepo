// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension API {
  class CreateLikeMutation: GraphQLMutation {
    public static let operationName: String = "CreateLike"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation CreateLike($input: CreateLikeInput!) { createLike(input: $input) { __typename match { __typename id targetUser { __typename id berealUsername externalProductUrl } } feedback { __typename id targetUserId } } }"#
      ))

    public var input: CreateLikeInput

    public init(input: CreateLikeInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: API.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { API.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("createLike", CreateLike.self, arguments: ["input": .variable("input")]),
      ] }

      /// LIKEを作成する
      public var createLike: CreateLike { __data["createLike"] }

      /// CreateLike
      ///
      /// Parent Type: `CreateLikeResponse`
      public struct CreateLike: API.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { API.Objects.CreateLikeResponse }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("match", Match?.self),
          .field("feedback", Feedback?.self),
        ] }

        /// マッチした場合のみ返却される
        public var match: Match? { __data["match"] }
        /// マッチしなかった場合のみ返却される
        public var feedback: Feedback? { __data["feedback"] }

        /// CreateLike.Match
        ///
        /// Parent Type: `Match`
        public struct Match: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.Match }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", API.ID.self),
            .field("targetUser", TargetUser.self),
          ] }

          /// match id
          public var id: API.ID { __data["id"] }
          /// マッチした相手
          public var targetUser: TargetUser { __data["targetUser"] }

          /// CreateLike.Match.TargetUser
          ///
          /// Parent Type: `User`
          public struct TargetUser: API.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: ApolloAPI.ParentType { API.Objects.User }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", API.ID.self),
              .field("berealUsername", String.self),
              .field("externalProductUrl", String.self),
            ] }

            /// user id
            public var id: API.ID { __data["id"] }
            /// BeRealのusername
            public var berealUsername: String { __data["berealUsername"] }
            public var externalProductUrl: String { __data["externalProductUrl"] }
          }
        }

        /// CreateLike.Feedback
        ///
        /// Parent Type: `Feedback`
        public struct Feedback: API.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { API.Objects.Feedback }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", API.ID.self),
            .field("targetUserId", API.ID.self),
          ] }

          /// feedback id
          public var id: API.ID { __data["id"] }
          /// target user id
          public var targetUserId: API.ID { __data["targetUserId"] }
        }
      }
    }
  }
}
