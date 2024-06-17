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

        Text("TenMatch is an application that allows you to exchange ten ten with everyone in Global!", bundle: .module)
          .font(.system(.headline, design: .rounded))
      }
      .padding(.horizontal, 56)
    }
    .foregroundStyle(Color.white)
  }
}
