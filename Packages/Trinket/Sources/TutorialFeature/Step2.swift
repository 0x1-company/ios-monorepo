import SwiftUI

struct Step2View: View {
  var body: some View {
    VStack(spacing: 24) {
      Text("Right if you are interested!", bundle: .module)
        .font(.system(.title, design: .rounded, weight: .bold))

      Text("If you both Like each other, a match is made. Let's give it a try right away!", bundle: .module)
        .font(.system(.headline, design: .rounded))
    }
    .padding(.horizontal, 56)
    .foregroundStyle(Color.white)
  }
}
