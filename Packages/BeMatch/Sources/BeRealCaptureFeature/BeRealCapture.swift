import AnalyticsClient
import BeMatch
import BeMatchClient
import ComposableArchitecture
import FeedbackGeneratorClient
import FirebaseAuthClient
import FirebaseStorageClient
import PhotosUI
import Styleguide
import SwiftUI

@Reducer
public struct BeRealCaptureLogic {
  public init() {}

  @ObservableState
  public struct State: Equatable {
    var photoPickerItems: [PhotosPickerItem] = []
    var images: [PhotoGrid.State] = Array(repeating: .empty, count: 9)
    var isActivityIndicatorVisible = false
    var isWarningTextVisible: Bool {
      !images.filter(\.isWarning).isEmpty
    }

    @Presents var destination: Destination.State?
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
    case updateUserImage(Result<BeMatch.UpdateUserImageMutation.Data, Error>)
    case destination(PresentationAction<Destination.Action>)
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum Delegate: Equatable {
      case nextScreen
      case howTo
    }
  }

  @Dependency(\.uuid) var uuid
  @Dependency(\.analytics) var analytics
  @Dependency(\.firebaseStorage) var firebaseStorage
  @Dependency(\.firebaseAuth) var firebaseAuth
  @Dependency(\.feedbackGenerator) var feedbackGenerator
  @Dependency(\.bematch.updateUserImage) var updateUserImage

  public var body: some Reducer<State, Action> {
    BindingReducer()
    Reduce<State, Action> { state, action in
      switch action {
      case .onTask:
        analytics.logScreen(screenName: "BeRealCapture", of: self)
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
        if let image = UIImage(data: data) {
          if image.size == CGSize(width: 1500, height: 2000) {
            state.images[offset] = .active(image)
          } else {
            state.images[offset] = .warning(image)
          }
        } else {
          state.images[offset] = .empty
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
        return .none

      case .nextButtonTapped:
        let notBeRealIamges = state.images.filter(\.isWarning)
        guard notBeRealIamges.isEmpty else {
          state.destination = .alert(.selectPhotoWithBeReal())
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
          var imageUrls: [URL] = []
          let userFolder = "users/profile_images/\(uid)"

          do {
            try await withThrowingTaskGroup(of: URL.self) { group in
              for imageState in validImages {
                guard let imageData = imageState.imageData else { return }
                group.addTask {
                  try await firebaseStorage.upload(
                    path: userFolder + "/\(uuid().uuidString).jpeg",
                    uploadData: imageData
                  )
                }
              }

              for try await result in group {
                imageUrls.append(result)
              }
            }
          } catch {
            await send(.uploadResponse(.failure(error)))
          }

          let input = BeMatch.UpdateUserImageInput(
            imageUrls: imageUrls.map(\.absoluteString)
          )
          await send(.updateUserImage(Result {
            try await updateUserImage(input)
          }))
        }

      case .uploadResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .updateUserImage(.success):
        state.isActivityIndicatorVisible = false
        return .send(.delegate(.nextScreen))

      case .updateUserImage(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case let .destination(.presented(.confirmationDialog(.distory(offset)))):
        state.images[offset] = .empty
        state.photoPickerItems.remove(at: offset)
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
}

public struct BeRealCaptureView: View {
  public enum NextButtonStyle: Equatable {
    case next
    case save
  }

  @Perception.Bindable var store: StoreOf<BeRealCaptureLogic>
  private let nextButtonStyle: NextButtonStyle

  public init(
    store: StoreOf<BeRealCaptureLogic>,
    nextButtonStyle: NextButtonStyle = .next
  ) {
    self.store = store
    self.nextButtonStyle = nextButtonStyle
  }

  public var body: some View {
    WithPerceptionTracking {
      VStack(spacing: 8) {
        ScrollView {
          VStack(spacing: 36) {
            VStack(spacing: 8) {
              Text("Set your saved photo to your profile (it will be public 🌏)", bundle: .module)
                .lineLimit(2)
                .frame(minHeight: 50)
                .layoutPriority(1)
                .font(.system(.title3, weight: .semibold))

              if store.isWarningTextVisible {
                Button {
                  store.send(.howToButtonTapped)
                } label: {
                  HStack(spacing: 2) {
                    Image(systemName: "exclamationmark.triangle.fill")
                      .foregroundStyle(Color.yellow)

                    Text("Select a photo saved with BeReal.", bundle: .module)
                      .foregroundStyle(Color.secondary)
                  }
                  .font(.callout)
                }
              }
            }

            LazyVGrid(
              columns: Array(
                repeating: GridItem(spacing: 16),
                count: 3
              ),
              alignment: .center,
              spacing: 16
            ) {
              ForEach(
                Array(store.images.enumerated()),
                id: \.offset
              ) { offset, state in
                PhotoGrid(
                  state: state,
                  selection: $store.photoPickerItems,
                  onDelete: {
                    store.send(.onDelete(offset))
                  }
                )
                .id(offset)
              }
            }
          }
          .padding(.top, 24)
        }

        PrimaryButton(
          nextButtonStyle == .save
            ? String(localized: "Save", bundle: .module)
            : String(localized: "Next", bundle: .module),
          isLoading: store.isActivityIndicatorVisible
        ) {
          store.send(.nextButtonTapped)
        }
      }
      .padding(.bottom, 16)
      .padding(.horizontal, 16)
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .task { await store.send(.onTask).finish() }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
      .alert(
        item: $store.scope(
          state: \.destination?.alert,
          action: \.destination.alert
        )
      )
      .confirmationDialog(
        item: $store.scope(
          state: \.destination?.confirmationDialog,
          action: \.destination.confirmationDialog
        )
      )
    }
  }
}

extension AlertState where Action == BeRealCaptureLogic.Destination.Action.Alert {
  static func pleaseSelectPhotos() -> Self {
    Self {
      TextState("Please select at least 3 saved photos.", bundle: .module)
    } actions: {
      ButtonState(action: .confirmOkay) {
        TextState("OK", bundle: .module)
      }
    }
  }
}

extension AlertState where Action == BeRealCaptureLogic.Destination.Action.Alert {
  static func selectPhotoWithBeReal() -> Self {
    Self {
      TextState("Select a photo saved with BeReal.", bundle: .module)
    } actions: {
      ButtonState(action: .confirmOkay) {
        TextState("OK", bundle: .module)
      }
    }
  }
}

extension ConfirmationDialogState where Action == BeRealCaptureLogic.Destination.Action.ConfirmationDialog {
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

#Preview {
  NavigationStack {
    BeRealCaptureView(
      store: .init(
        initialState: BeRealCaptureLogic.State(),
        reducer: { BeRealCaptureLogic() }
      ),
      nextButtonStyle: .next
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
