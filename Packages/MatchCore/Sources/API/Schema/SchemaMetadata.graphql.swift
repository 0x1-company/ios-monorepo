// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol API_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
  where Schema == API.SchemaMetadata {}

public protocol API_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
  where Schema == API.SchemaMetadata {}

public protocol API_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
  where Schema == API.SchemaMetadata {}

public protocol API_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
  where Schema == API.SchemaMetadata {}

public extension API {
  typealias SelectionSet = API_SelectionSet

  typealias InlineFragment = API_InlineFragment

  typealias MutableSelectionSet = API_MutableSelectionSet

  typealias MutableInlineFragment = API_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Mutation": return API.Objects.Mutation
      case "User": return API.Objects.User
      case "ShortComment": return API.Objects.ShortComment
      case "FirebaseRegistrationToken": return API.Objects.FirebaseRegistrationToken
      case "CreateLikeResponse": return API.Objects.CreateLikeResponse
      case "Match": return API.Objects.Match
      case "Feedback": return API.Objects.Feedback
      case "Message": return API.Objects.Message
      case "UserImage": return API.Objects.UserImage
      case "Query": return API.Objects.Query
      case "MatchConnection": return API.Objects.MatchConnection
      case "PageInfo": return API.Objects.PageInfo
      case "MatchEdge": return API.Objects.MatchEdge
      case "MessageConnection": return API.Objects.MessageConnection
      case "MessageEdge": return API.Objects.MessageEdge
      case "Explorer": return API.Objects.Explorer
      case "ProductList": return API.Objects.ProductList
      case "MembershipProduct": return API.Objects.MembershipProduct
      case "UserCategory": return API.Objects.UserCategory
      case "PushNotificationBadge": return API.Objects.PushNotificationBadge
      case "MessageRoomConnection": return API.Objects.MessageRoomConnection
      case "MessageRoomEdge": return API.Objects.MessageRoomEdge
      case "MessageRoom": return API.Objects.MessageRoom
      case "PremiumMembership": return API.Objects.PremiumMembership
      case "InvitationCode": return API.Objects.InvitationCode
      case "ReceivedLike": return API.Objects.ReceivedLike
      case "Achievement": return API.Objects.Achievement
      case "Banner": return API.Objects.Banner
      case "InvitationCampaign": return API.Objects.InvitationCampaign
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}
}
