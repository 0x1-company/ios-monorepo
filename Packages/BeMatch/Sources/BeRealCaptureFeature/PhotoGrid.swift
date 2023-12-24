import CachedAsyncImage
import PhotosUI
import Styleguide
import SwiftUI

struct PhotoGrid: View {
  let image: URL?
  @Binding var selection: [PhotosPickerItem]
  let onDelete: () -> Void

  var body: some View {
    CachedAsyncImage(
      url: image,
      urlCache: .shared,
      scale: 1,
      content: { content in
        Button(action: onDelete) {
          content
            .resizable()
            .aspectRatio(3 / 4, contentMode: .fill)
            .clipped()
            .cornerRadius(10)
            .overlay {
              RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: UIColor.opaqueSeparator), lineWidth: 1)
            }
        }
      },
      placeholder: {
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
      }
    )
    .buttonStyle(HoldDownButtonStyle())
  }
}

#Preview {
  PhotoGrid(
    image: nil,
    selection: .constant([]),
    onDelete: {}
  )
  .frame(width: 104)
}
