import Styleguide
import SwiftUI

struct PlusIcon: View {
  var body: some View {
    Image(systemName: "plus")
      .frame(width: 32, height: 32)
      .foregroundStyle(Color.black)
      .background(Color.white)
      .clipShape(Circle())
  }
}

#Preview {
  PlusIcon()
}
