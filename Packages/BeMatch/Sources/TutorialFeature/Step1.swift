import SwiftUI

struct Step1View: View {
  var body: some View {
    VStack(spacing: 40) {
      Image(ImageResource.wavingHand)
        .resizable()
        .frame(width: 40, height: 40)

      VStack(spacing: 16) {
        Text("Let's get started!", bundle: .module)
          .font(.system(.title, design: .rounded, weight: .bold))

        Text("BeMatch is an app that lets you make friends with people all over the world.", bundle: .module)
          .font(.system(.headline, design: .rounded))
      }
      .padding(.horizontal, 56)
    }
    .foregroundStyle(Color.white)
  }
}
