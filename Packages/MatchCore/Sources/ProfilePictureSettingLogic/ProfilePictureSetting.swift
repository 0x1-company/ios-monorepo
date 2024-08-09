import AnalyticsClient
import API
import APIClient
import ComposableArchitecture
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

  public struct State: Equatable {
    @BindingState public var photoPickerItems: [PhotosPickerItem] = []
    public var images: [PhotoGridState] = Array(repeating: .empty, count: 9)
    public var isActivityIndicatorVisible = false
    public var isWarningTextVisible: Bool {
      !images.filter(\.isWarning).isEmpty
    }

    @PresentationState public var destination: Destination.State?
    public init() {}
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

      case .binding(\.$photoPickerItems):
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
        if isValidSize(for: brand, size: image.size) {
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
          var imageUrls: [Int: URL] = [:]
          let userFolder = "users/profile_images/\(uid)"

          do {
            for (order, imageState) in validImages.enumerated() {
              guard let imageData = imageState.imageData else { return }
              let imageUrl = try await firebaseStorage.upload(
                path: userFolder + "/\(uuid().uuidString).jpeg",
                uploadData: imageData
              )
              imageUrls[order] = imageUrl
            }
          } catch {
            await send(.uploadResponse(.failure(error)))
          }

          let inputs = imageUrls.map { order, imageUrl in
            API.UpdateUserImageV2Input(imageUrl: imageUrl.absoluteString, order: order)
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
    .ifLet(\.$destination, action: \.destination) {
      Destination()
    }
  }

  @Reducer
  public struct Destination {
    public enum State: Equatable {
      case alert(AlertState<Action.Alert>)
      case confirmationDialog(ConfirmationDialogState<Action.ConfirmationDialog>)
    }

    public enum Action {
      case alert(Alert)
      case confirmationDialog(ConfirmationDialog)

      public enum Alert: Equatable {
        case confirmOkay
      }

      public enum ConfirmationDialog: Equatable {
        case distory(Int)
      }
    }

    public var body: some Reducer<State, Action> {
      Scope(state: \.alert, action: \.alert) {}
      Scope(state: \.confirmationDialog, action: \.confirmationDialog) {}
    }
  }

  func isValidSize(for brand: EnvironmentClient.Brand, size: CGSize) -> Bool {
    switch brand {
    case .bematch:
      return size == CGSize(width: 1500, height: 2000)
    case .picmatch:
      return true
    case .tapmatch:
      return size.width == size.height
    case .tenmatch:
      return true
    case .trinket:
      return size.width == size.height
    }
  }
}

extension AlertState where Action == ProfilePictureSettingLogic.Destination.Action.Alert {
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

extension ConfirmationDialogState where Action == ProfilePictureSettingLogic.Destination.Action.ConfirmationDialog {
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
