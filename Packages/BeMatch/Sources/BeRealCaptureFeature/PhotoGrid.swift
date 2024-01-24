import PhotosUI
import Styleguide
import SwiftUI

struct PhotoGrid: View {
  let imageData: Data?
  @Binding var selection: [PhotosPickerItem]
  let onDelete: () -> Void

  var body: some View {
    if let imageData, let image = UIImage(data: imageData) {
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
    } else {
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
    imageData: nil,
    selection: .constant([]),
    onDelete: {}
  )
  .frame(width: 104)
}
