// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol FlyCam_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
  where Schema == FlyCam.SchemaMetadata {}

public protocol FlyCam_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
  where Schema == FlyCam.SchemaMetadata {}

public protocol FlyCam_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
  where Schema == FlyCam.SchemaMetadata {}

public protocol FlyCam_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
  where Schema == FlyCam.SchemaMetadata {}

public extension FlyCam {
  typealias ID = String

  typealias SelectionSet = FlyCam_SelectionSet

  typealias InlineFragment = FlyCam_InlineFragment

  typealias MutableSelectionSet = FlyCam_MutableSelectionSet

  typealias MutableInlineFragment = FlyCam_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    public static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Mutation": return FlyCam.Objects.Mutation
      case "FirebaseRegistrationToken": return FlyCam.Objects.FirebaseRegistrationToken
      case "User": return FlyCam.Objects.User
      case "Query": return FlyCam.Objects.Query
      case "PushNotificationBadge": return FlyCam.Objects.PushNotificationBadge
      case "Banner": return FlyCam.Objects.Banner
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}
}
