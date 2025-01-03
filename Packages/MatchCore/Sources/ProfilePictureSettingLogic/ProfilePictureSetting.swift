import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
import CryptoKit
import EnvironmentClient
import FeedbackGeneratorClient
import FirebaseAuthClient
import FirebaseStorageClient
import PhotosUI
import SwiftUI

public enum PhotoGridState: Equatable {
  case active(UIImage)
  case warning(UIImage)
  case empty

  var isActive: Bool {
    guard case .active = self else {
      return false
    }
    return true
  }

  var isWarning: Bool {
    guard case .warning = self else {
      return false
    }
    return true
  }

  var imageData: Data? {
    guard case let .active(uIImage) = self else {
      return nil
    }
    return uIImage.jpegData(compressionQuality: 1)
  }
}

@Reducer
public struct ProfilePictureSettingLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    public let allowNonExternalProductPhoto: Bool
    @Presents public var destination: Destination.State?
    public var photoPickerItems: [PhotosPickerItem] = []
    public var images: [PhotoGridState] = Array(repeating: .empty, count: 9)
    public var isActivityIndicatorVisible = false
    public var isWarningTextVisible: Bool {
      !images.filter(\.isWarning).isEmpty
    }

    public init(allowNonExternalProductPhoto: Bool = false) {
      self.allowNonExternalProductPhoto = allowNonExternalProductPhoto
    }
  }

  public enum Action: BindableAction {
    case onTask
    case onDelete(Int)
    case howToButtonTapped
    case nextButtonTapped
    case loadTransferableResponse(Int, Result<Data?, Error>)
    case loadTransferableFinished
    case uploadResponse(Result<URL, Error>)
    case updateUserImageV2(Result<API.UpdateUserImageV2Mutation.Data, Error>)
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case nextScreen
      case howTo
    }
  }

  @Dependency(\.api) var api
  @Dependency(\.uuid) var uuid
  @Dependency(\.analytics) var analytics
  @Dependency(\.environment) var environment
  @Dependency(\.firebaseAuth) var firebaseAuth
  @Dependency(\.firebaseStorage) var firebaseStorage
  @Dependency(\.feedbackGenerator) var feedbackGenerator

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "ProfilePictureSetting", of: self)
        return .none

      case let .onDelete(offset):
        state.destination = .confirmationDialog(.deletePhoto(offset))
        return .none

      case .howToButtonTapped:
        return .send(.delegate(.howTo))

      case .binding(\.photoPickerItems):
        guard !state.photoPickerItems.isEmpty
        else { return .none }

        state.isActivityIndicatorVisible = true

        return .run { [items = state.photoPickerItems] send in
          for (offset, element) in items.enumerated() {
            await send(.loadTransferableResponse(offset, Result {
              try await element.loadTransferable(type: Data.self)
            }))
          }
          await send(.loadTransferableFinished)
        }

      case let .loadTransferableResponse(offset, .success(.some(data))):
        guard let image = UIImage(data: data) else {
          state.images[offset] = .empty
          return .none
        }
        let brand = environment.brand()
        if isValidSize(for: brand, size: image.size, allowNonExternalProductPhoto: state.allowNonExternalProductPhoto) {
          state.images[offset] = .active(image)
        } else {
          state.images[offset] = .warning(image)
        }
        return .none

      case let .loadTransferableResponse(offset, .success(.none)):
        state.images[offset] = .empty
        return .none

      case let .loadTransferableResponse(offset, .failure):
        state.images[offset] = .empty
        state.isActivityIndicatorVisible = false
        return .none

      case .loadTransferableFinished:
        state.isActivityIndicatorVisible = false
        state.photoPickerItems.removeAll()
        return .none

      case .nextButtonTapped:
        let notBeRealIamges = state.images.filter(\.isWarning)
        let externalProduct = environment.brand().externalProduct
        guard notBeRealIamges.isEmpty else {
          state.destination = .alert(.validateError(externalProduct: externalProduct))
          return .none
        }

        let validImages = state.images.filter(\.isActive)
        guard validImages.count >= 3 else {
          state.destination = .alert(.pleaseSelectPhotos())
          return .none
        }

        guard let uid = firebaseAuth.currentUser()?.uid
        else { return .none }

        state.isActivityIndicatorVisible = true

        return .run { send in
          var images: [Int: (url: URL, digest: String)] = [:]
          let userFolder = "users/profile_images/\(uid)"

          do {
            for (order, imageState) in validImages.enumerated() {
              guard let imageData = imageState.imageData else { return }
              let imageUrl = try await firebaseStorage.upload(
                path: userFolder + "/\(uuid().uuidString).jpeg",
                uploadData: imageData
              )
              let digest = SHA256.hash(data: imageData)
                .compactMap { String(format: "%02x", $0) }
                .joined()
              images[order] = (imageUrl, digest)
            }
          } catch {
            await send(.uploadResponse(.failure(error)))
          }

          let inputs = images.map { order, imageInfo in
            API.UpdateUserImageV2Input(
              imageHash: .some(imageInfo.digest),
              imageUrl: imageInfo.url.absoluteString,
              order: order
            )
          }

          await send(.updateUserImageV2(Result {
            try await api.updateUserImageV2(inputs)
          }))
        }

      case .uploadResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .updateUserImageV2(.success):
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.nextScreen))

      case .updateUserImageV2(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case let .destination(.presented(.confirmationDialog(.distory(offset)))):
        state.images[offset] = .empty
        state.destination = nil
        return .none

      case .destination(.presented(.alert(.confirmOkay))):
        state.destination = nil
        return .send(.delegate(.howTo))

      default:
        return .none
      }
    }
    .ifLet(\.$destination, action: \.destination)
  }

  @Reducer(state: .equatable)
  public enum Destination {
    case alert(AlertState<Alert>)
    case confirmationDialog(ConfirmationDialogState<ConfirmationDialog>)

    @CasePathable
    public enum Alert: Equatable {
      case confirmOkay
    }

    public enum ConfirmationDialog: Equatable {
      case distory(Int)
    }
  }

  func isValidSize(
    for brand: EnvironmentClient.Brand,
    size: CGSize,
    allowNonExternalProductPhoto: Bool
  ) -> Bool {
    switch brand {
    case .bematch:
      return true
    case .picmatch:
      return true
    case .tapmatch:
      return true
    case .tenmatch:
      return true
    case .trinket:
      return size.width == size.height
    }
  }
}

extension AlertState where Action == ProfilePictureSettingLogic.Destination.Alert {
  static func pleaseSelectPhotos() -> Self {
    Self {
      TextState("Please select at least 3 saved photos.", bundle: .module)
    } actions: {
      ButtonState(action: .confirmOkay) {
        TextState("OK", bundle: .module)
      }
    }
  }

  static func validateError(externalProduct: String) -> Self {
    Self {
      TextState("Select a photo saved with \(externalProduct)", bundle: .module)
    } actions: {
      ButtonState(action: .confirmOkay) {
        TextState("OK", bundle: .module)
      }
    }
  }
}

extension ConfirmationDialogState where Action == ProfilePictureSettingLogic.Destination.ConfirmationDialog {
  static func deletePhoto(_ offset: Int) -> Self {
    Self {
      TextState("Edit Profile", bundle: .module)
    } actions: {
      ButtonState(role: .destructive, action: .distory(offset)) {
        TextState("Delete a photo", bundle: .module)
      }
    }
  }
}
