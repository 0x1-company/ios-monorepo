import Styleguide
import SwiftUI

struct HowToReceiveBenefitView: View {
  let displayDuration: String

  var body: some View {
    VStack(spacing: 24) {
      VStack(spacing: 8) {
        Text("1. Send invitation code", bundle: .module)
          .font(.system(.title3, weight: .semibold))

        Text("Send an invitation code to a friend who hasn't used BeMatch.", bundle: .module)
      }

      Image(ImageResource.line)
        .resizable()
        .aspectRatio(contentMode: .fit)

      VStack(spacing: 8) {
        Text("2. \(displayDuration) free for both parties!", bundle: .module)
          .font(.system(.title3, weight: .semibold))

        Text("When they enter the Invitation Code and register, you will both receive BeMatch PRO for sure!", bundle: .module)
      }

      Image(ImageResource.invitationCodeSample)
        .resizable()
        .aspectRatio(contentMode: .fit)
    }
    .padding(.all, 16)
    .padding(.top, 44)
    .padding(.bottom, 20)
    .multilineTextAlignment(.center)
    .background(Color(uiColor: UIColor.secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .overlay(alignment: .top) {
      Text("How to Receive Benefits", bundle: .module)
        .font(.system(.title2, weight: .semibold))
        .frame(height: 40)
        .padding(.horizontal, 8)
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
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .offset(y: -20)
    }
  }
}

#Preview {
  NavigationStack {
    HowToReceiveBenefitView(
      displayDuration: "1 week"
    )
  }
  .environment(\.colorScheme, .dark)
}
