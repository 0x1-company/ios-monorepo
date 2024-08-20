import SwiftUI

struct Step3View: View {
  var body: some View {
    VStack(spacing: 24) {
      Text("Hmmm... left when", bundle: .module)
        .font(.system(.title, weight: .bold))

      Text(#"If you think, "Maybe not...", swipe left. If you think it's not quite right, swipe left."#, bundle: .module)
        .font(.system(.headline, design: .rounded))
    }
    .padding(.horizontal, 56)
    .foregroundStyle(Color.white)
  }
}
