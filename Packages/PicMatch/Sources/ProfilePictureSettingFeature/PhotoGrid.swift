import PhotosUI
import ProfilePictureSettingLogic
import Styleguide
import SwiftUI

public struct PhotoGrid: View {
  let state: PhotoGridState
  @Binding var selection: [PhotosPickerItem]
  let onDelete: () -> Void

  public var body: some View {
    switch state {
    case let .active(image):
      Button(action: onDelete) {
        Rectangle()
          .aspectRatio(2 / 3, contentMode: .fill)
          .overlay {
            Image(uiImage: image)
              .resizable()
              .scaledToFill()
          }
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .buttonStyle(HoldDownButtonStyle())
    case let .warning(image):
      Button(action: onDelete) {
        ZStack {
          Image(uiImage: image)
            .resizable()

          Color.black.opacity(0.8)

          Image(systemName: "exclamationmark.triangle.fill")
            .frame(width: 32, height: 32)
            .foregroundStyle(Color.yellow)
        }
        .aspectRatio(3 / 4, contentMode: .fill)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 10))
      }
      .buttonStyle(HoldDownButtonStyle())
    case .empty:
      PhotosPicker(
        selection: $selection,
        maxSelectionCount: 9,
        selectionBehavior: .default,
        preferredItemEncoding: .automatic
      ) {
        Color(uiColor: UIColor.secondarySystemFill)
          .aspectRatio(3 / 4, contentMode: .fill)
          .cornerRadius(10)
          .overlay {
            PlusIcon()
          }
      }
      .buttonStyle(HoldDownButtonStyle())
    }
  }
}

#Preview {
  PhotoGrid(
    state: .empty,
    selection: .constant([]),
    onDelete: {}
  )
  .frame(width: 104)
}
