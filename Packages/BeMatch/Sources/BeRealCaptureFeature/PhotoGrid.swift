import PhotosUI
import Styleguide
import SwiftUI

public struct PhotoGrid: View {
  let state: State
  @Binding var selection: [PhotosPickerItem]
  let onDelete: () -> Void

  public enum State {
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

  public var body: some View {
    switch state {
    case let .active(image):
      Button(action: onDelete) {
        Image(uiImage: image)
          .resizable()
          .aspectRatio(3 / 4, contentMode: .fill)
          .clipped()
          .clipShape(RoundedRectangle(cornerRadius: 10))
          .overlay {
            RoundedRectangle(cornerRadius: 10)
              .stroke(Color(uiColor: UIColor.opaqueSeparator), lineWidth: 1)
          }
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
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color(uiColor: UIColor.opaqueSeparator), lineWidth: 1)
        }
      }
      .buttonStyle(HoldDownButtonStyle())
    case .empty:
      PhotosPicker(
        selection: $selection,
        maxSelectionCount: 9,
        selectionBehavior: .default,
        preferredItemEncoding: .automatic
      ) {
        Color(uiColor: UIColor.secondarySystemBackground)
          .aspectRatio(3 / 4, contentMode: .fill)
          .cornerRadius(10)
          .overlay {
            PlusIcon()
          }
          .overlay {
            RoundedRectangle(cornerRadius: 10)
              .stroke(
                Color(uiColor: UIColor.opaqueSeparator),
                style: StrokeStyle(dash: [8, 8])
              )
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
