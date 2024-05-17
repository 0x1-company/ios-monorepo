import API
import CachedAsyncImage
import ComposableArchitecture
import ProfileExternalLogic
import ProfileSharedFeature
import ReportFeature
import Styleguide
import SwiftUI

public struct ProfileExternalView: View {
  @Environment(\.displayScale) var displayScale
  @State var translation: CGSize = .zero
  @State var scaleEffect: Double = 1.0
  let store: StoreOf<ProfileExternalLogic>

  public init(store: StoreOf<ProfileExternalLogic>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(store, observe: { $0 }) { viewStore in
      VStack {
        VStack(spacing: 24) {
          HStack(spacing: 0) {
            Button {
              store.send(.closeButtonTapped)
            } label: {
              Image(systemName: "chevron.down")
                .bold()
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 44)
            }
            Spacer()
            VStack(spacing: 0) {
              Text(viewStore.match.targetUser.displayName ?? viewStore.match.targetUser.berealUsername)
                .foregroundStyle(Color.white)
                .font(.system(.callout, weight: .semibold))

              Text(viewStore.createdAt, format: Date.FormatStyle(date: .numeric))
                .foregroundStyle(Color.gray)
                .font(.system(.caption2, weight: .semibold))
            }
            Spacer()
            Menu {
              Button(role: .destructive) {
                store.send(.unmatchButtonTapped)
              } label: {
                Label {
                  Text("Unmatch", bundle: .module)
                } icon: {
                  Image(systemName: "trash")
                }
              }

              Button {
                store.send(.reportButtonTapped)
              } label: {
                Text("Report", bundle: .module)
              }

              Button {
                store.send(.unmatchButtonTapped)
              } label: {
                Text("Block", bundle: .module)
              }
            } label: {
              Image(systemName: "ellipsis")
                .bold()
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 44)
            }
          }
          .padding(.top, 56)
          .padding(.horizontal, 16)

          IfLetStore(
            store.scope(state: \.pictureSlider, action: \.pictureSlider),
            then: PictureSliderView.init(store:),
            else: {
              Color.black
                .aspectRatio(3 / 4, contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width)
            }
          )

          VStack(spacing: 12) {
            PrimaryButton(
              String(localized: "Add BeReal", bundle: .module)
            ) {
              store.send(.addBeRealButtonTapped)
            }
            .padding(.horizontal, 16)
          }

          Spacer()
        }
        .background(Color.black)
        .cornerRadius(40)
        .scaleEffect(scaleEffect)
        .ignoresSafeArea()
      }
      .background(Material.ultraThin)
      .task { await store.send(.onTask).finish() }
      .confirmationDialog(
        store: store.scope(
          state: \.$destination.confirmationDialog,
          action: \.destination.confirmationDialog
        )
      )
      .sheet(
        store: store.scope(state: \.$destination.report, action: \.destination.report),
        content: ReportView.init(store:)
      )
      .gesture(
        DragGesture()
          .onEnded { _ in
            translation = .zero
            scaleEffect = 1.0
          }
          .onChanged {
            translation = $0.translation

            let startValue = 0.85
            let endValue = 1.0

            let clampedValue = min(max(translation.height, 0.0), 150.0)
            let normalizedValue = clampedValue / 100.0

            scaleEffect = startValue + (endValue - startValue) * (1.0 - normalizedValue)

            if translation.height > 150 {
              store.send(.closeButtonTapped)
            }
          }
      )
    }
  }
}

#Preview {
  Color.black
    .fullScreenCover(isPresented: .constant(true)) {
      ProfileExternalView(
        store: .init(
          initialState: ProfileExternalLogic.State(
            match: API.MatchGrid(
              _dataDict: DataDict(
                data: [
                  "id": "1",
                  "isRead": 0,
                  "createdAt": "1702462075770",
                  "targetUser": DataDict(
                    data: [
                      "id": "2",
                      "berealUsername": "tomomisun",
                      "images": [
                        DataDict(
                          data: [
                            "id": "3",
                            "imageUrl": "https://asia-northeast1-bematch-staging.cloudfunctions.net/onRequestResizedImage/users/profile_images/vJ2NQU467OgyW6czPxFvfWoUOFC2/0.png?size=1500x2000",
                          ],
                          fulfilledFragments: []
                        ),
                      ],
                    ],
                    fulfilledFragments: []
                  ),
                ],
                fulfilledFragments: []
              )
            )
          ),
          reducer: { ProfileExternalLogic() }
        )
      )
      .environment(\.colorScheme, .dark)
    }
}
