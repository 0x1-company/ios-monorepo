// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public extension BeMatch {
  class UpdateGenderMutation: GraphQLMutation {
    public static let operationName: String = "UpdateGender"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"mutation UpdateGender($input: UpdateGenderInput!) { updateGender(input: $input) { __typename id gender } }"#
      ))

    public var input: UpdateGenderInput

    public init(input: UpdateGenderInput) {
      self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: BeMatch.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.Mutation }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("updateGender", UpdateGender.self, arguments: ["input": .variable("input")]),
      ] }

      /// 性別を更新する
      public var updateGender: UpdateGender { __data["updateGender"] }

      /// UpdateGender
      ///
      /// Parent Type: `User`
      public struct UpdateGender: BeMatch.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { BeMatch.Objects.User }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", BeMatch.ID.self),
          .field("gender", GraphQLEnum<BeMatch.Gender>.self),
        ] }

        /// user id
        public var id: BeMatch.ID { __data["id"] }
        /// gender
        public var gender: GraphQLEnum<BeMatch.Gender> { __data["gender"] }
      }
    }
  }
}
