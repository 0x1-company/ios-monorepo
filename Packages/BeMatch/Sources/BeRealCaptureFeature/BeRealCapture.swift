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
import TcaHelpers

@Reducer
public struct BeRealCaptureLogic {
  public init() {}

  public struct State: Equatable {
    @BindingState var photoPickerItems: [PhotosPickerItem] = []
    var images: [URL?] = Array(repeating: nil, count: 9)
    var isActivityIndicatorVisible = false
    var isDisabled = true
    @PresentationState var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?
    public init() {}
  }

  public enum Action: BindableAction {
    case onAppear
    case onDelete(Int)
    case nextButtonTapped
    case loadTransferableResponse(Result<Data?, Error>)
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

      case .nextButtonTapped:
        state.isActivityIndicatorVisible = true
        let imageUrls = state.images
          .compactMap { $0 }
          .map(\.absoluteString)
        let input = BeMatch.UpdateUserImageInput(imageUrls: imageUrls)
        return .run { send in
          await feedbackGenerator.impactOccurred()
          await send(.updateUserImage(Result {
            try await updateUserImage(input)
          }), animation: .default)
        }

      case .binding(\.$photoPickerItems):
        guard
          !state.photoPickerItems.isEmpty,
          let uid = firebaseAuth.currentUser()?.uid
        else { return .none }

        state.isActivityIndicatorVisible = true
        state.images = Array(repeating: nil, count: 9)

        return .run { [items = state.photoPickerItems] send in
          for i in items {
            await send(.loadTransferableResponse(Result {
              try await i.loadTransferable(type: Data.self)
            }))
            let data = try await i.loadTransferable(type: Data.self)
            guard let data else { return }
            let filename = "\(uuid().uuidString).png"
            await send(.uploadResponse(Result {
              try await firebaseStorage.upload(
                path: "users/profile_images/\(uid)/\(filename)",
                uploadData: data
              )
            }))
          }
        }

      case let .uploadResponse(.success(url)):
        state.isActivityIndicatorVisible = false
        for i in 0 ..< state.images.count {
          if state.images[i] == nil {
            state.images[i] = url
            break
          }
        }
        return .none

      case .uploadResponse(.failure):
        state.isActivityIndicatorVisible = false
        return .none

      case .updateUserImage(.success):
        state.isActivityIndicatorVisible = false
        URLCache.shared.removeAllCachedResponses()
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
    .onChange(of: \.images) { images, state, _ in
      state.isDisabled = images.compactMap { $0 }.count < 3
      return .none
    }
  }
}

public struct BeRealCaptureView: View {
  let store: StoreOf<BeRealCaptureLogic>

  public init(store: StoreOf<BeRealCaptureLogic>) {
    self.store = store
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
            ) { offset, image in
              PhotoGrid(
                image: image,
                selection: viewStore.$photoPickerItems,
                onDelete: {
                  store.send(.onDelete(offset))
                }
              )
              .id(offset)
            }
          }

          PrimaryButton(
            String(localized: "Next", bundle: .module),
            isLoading: viewStore.isActivityIndicatorVisible,
            isDisabled: viewStore.isDisabled
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
      )
    )
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
