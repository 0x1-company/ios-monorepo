
import SwiftUI

struct PlusIcon: View {
  var body: some View {
    Image(systemName: "plus")
      .frame(width: 32, height: 32)
      .foregroundStyle(Color.white)
      .background(
        LinearGradient(
          colors: [
            Color(0xFFFD_2D76),
            Color(0xFFFE_7056),
          ],
          startPoint: .bottomLeading,
          endPoint: .topTrailing
        )
      )
      .clipShape(Circle())
      .overlay {
        RoundedRectangle(cornerRadius: 32 / 2)
          .stroke(Color.white, lineWidth: 1)
      }
  }
}

#Preview {
  PlusIcon()
}
