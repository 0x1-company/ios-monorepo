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

  public struct State: Equatable {
    @BindingState var photoPickerItems: [PhotosPickerItem] = []
    var images: [Data?] = Array(repeating: nil, count: 9)
    var isActivityIndicatorVisible = false

    @PresentationState var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    public init() {}
  }

  public enum Action: BindableAction {
    case onAppear
    case onDelete(Int)
    case nextButtonTapped
    case loadTransferableResponse(Int, Result<Data?, Error>)
    case loadTransferableFinished
    case uploadResponse(Result<URL, Error>)
    case updateUserImage(Result<BeMatch.UpdateUserImageMutation.Data, Error>)
    case confirmationDialog(PresentationAction<ConfirmationDialog>)
    case binding(BindingAction<State>)
    case delegate(Delegate)

    public enum ConfirmationDialog: Equatable {
      case distory(Int)
    }

    public enum Delegate: Equatable {
      case nextScreen
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
      case .onAppear:
        analytics.logScreen(screenName: "BeRealCapture", of: self)
        return .none

      case let .onDelete(offset):
        state.confirmationDialog = ConfirmationDialogState {
          TextState("Edit Profile", bundle: .module)
        } actions: {
          ButtonState(role: .destructive, action: .distory(offset)) {
            TextState("Delete a photo", bundle: .module)
          }
        } message: {
          TextState("Edit Profile", bundle: .module)
        }
        return .none

      case .binding(\.$photoPickerItems):
        guard !state.photoPickerItems.isEmpty
        else { return .none }

        state.isActivityIndicatorVisible = true
        state.images = Array(repeating: nil, count: 9)

        return .run { [items = state.photoPickerItems] send in
          for (offset, element) in items.enumerated() {
            await send(.loadTransferableResponse(offset, Result {
              try await element.loadTransferable(type: Data.self)
            }))
          }
          await send(.loadTransferableFinished)
        }
        
      case let .loadTransferableResponse(offset, .success(data)):
        state.images[offset] = data
        return .none
        
      case let .loadTransferableResponse(offset, .failure):
        state.images[offset] = nil
        state.isActivityIndicatorVisible = false
        return .none
        
      case .loadTransferableFinished:
        state.isActivityIndicatorVisible = false
        return .none
        
      case .nextButtonTapped:
        guard let uid = firebaseAuth.currentUser()?.uid
        else { return .none }
        
        let validImages = state.images.compactMap { $0 }
        guard validImages.count >= 3 else {
          return .none
        }
        
        state.isActivityIndicatorVisible = true

        return .run { send in
          var imageUrls: [URL] = []
          let userFolder = "users/profile_images/\(uid)"
          
          do {
            try await withThrowingTaskGroup(of: URL.self) { group in
              for imageData in validImages {
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

      case let .confirmationDialog(.presented(.distory(offset))):
        state.images[offset] = nil
        state.photoPickerItems.remove(at: offset)
        state.confirmationDialog = nil
        return .none

      default:
        return .none
      }
    }
  }
}

public struct BeRealCaptureView: View {
  public enum NextButtonStyle: Equatable {
    case next
    case save
  }

  let store: StoreOf<BeRealCaptureLogic>
  private let nextButtonStyle: NextButtonStyle

  public init(
    store: StoreOf<BeRealCaptureLogic>,
    nextButtonStyle: NextButtonStyle = .next
  ) {
    self.store = store
    self.nextButtonStyle = nextButtonStyle
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      ScrollView {
        VStack(spacing: 36) {
          Text("Set your saved photo to your profile (it will be public 🌏)", bundle: .module)
            .lineLimit(2)
            .frame(minHeight: 50)
            .layoutPriority(1)
            .font(.system(.title3, weight: .semibold))

          LazyVGrid(
            columns: Array(
              repeating: GridItem(spacing: 16),
              count: 3
            ),
            alignment: .center,
            spacing: 16
          ) {
            ForEach(
              Array(viewStore.images.enumerated()),
              id: \.offset
            ) { offset, imageData in
              PhotoGrid(
                imageData: imageData,
                selection: viewStore.$photoPickerItems,
                onDelete: {
                  store.send(.onDelete(offset))
                }
              )
              .id(offset)
            }
          }
          
          Spacer()

          PrimaryButton(
            nextButtonStyle == .save
              ? String(localized: "Save", bundle: .module)
              : String(localized: "Next", bundle: .module),
            isLoading: viewStore.isActivityIndicatorVisible
          ) {
            store.send(.nextButtonTapped)
          }
        }
        .padding(.top, 24)
        .padding(.bottom, 16)
        .padding(.horizontal, 16)
      }
      .multilineTextAlignment(.center)
      .navigationBarTitleDisplayMode(.inline)
      .onAppear { store.send(.onAppear) }
      .toolbar {
        ToolbarItem(placement: .principal) {
          Image(ImageResource.beMatch)
        }
      }
      .confirmationDialog(
        store: store.scope(state: \.$confirmationDialog, action: \.confirmationDialog)
      )
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
