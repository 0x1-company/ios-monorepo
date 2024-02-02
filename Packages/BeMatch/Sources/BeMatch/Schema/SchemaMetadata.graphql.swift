// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol BeMatch_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
  where Schema == BeMatch.SchemaMetadata {}

public protocol BeMatch_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
  where Schema == BeMatch.SchemaMetadata {}

public protocol BeMatch_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
  where Schema == BeMatch.SchemaMetadata {}

public protocol BeMatch_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
  where Schema == BeMatch.SchemaMetadata {}

public extension BeMatch {
  typealias ID = String

  typealias SelectionSet = BeMatch_SelectionSet

  typealias InlineFragment = BeMatch_InlineFragment

  typealias MutableSelectionSet = BeMatch_MutableSelectionSet

  typealias MutableInlineFragment = BeMatch_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Mutation": return BeMatch.Objects.Mutation
      case "User": return BeMatch.Objects.User
      case "ShortComment": return BeMatch.Objects.ShortComment
      case "FirebaseRegistrationToken": return BeMatch.Objects.FirebaseRegistrationToken
      case "CreateLikeResponse": return BeMatch.Objects.CreateLikeResponse
      case "Match": return BeMatch.Objects.Match
      case "Feedback": return BeMatch.Objects.Feedback
      case "UserImage": return BeMatch.Objects.UserImage
      case "Query": return BeMatch.Objects.Query
      case "UserCategory": return BeMatch.Objects.UserCategory
      case "LinearGradient": return BeMatch.Objects.LinearGradient
      case "PushNotificationBadge": return BeMatch.Objects.PushNotificationBadge
      case "InvitationCode": return BeMatch.Objects.InvitationCode
      case "ReceivedLike": return BeMatch.Objects.ReceivedLike
      case "MatchConnection": return BeMatch.Objects.MatchConnection
      case "PageInfo": return BeMatch.Objects.PageInfo
      case "MatchEdge": return BeMatch.Objects.MatchEdge
      case "InvitationCampaign": return BeMatch.Objects.InvitationCampaign
      case "Banner": return BeMatch.Objects.Banner
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}
}
