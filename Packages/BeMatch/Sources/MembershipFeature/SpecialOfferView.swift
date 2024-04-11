import SwiftUI
import Styleguide

public struct SpecialOfferView: View {
  @Environment(\.locale) var locale

  public var body: some View {
    VStack(spacing: 24) {
      Text("See who sent it!", bundle: .module)
        .font(.title3)
        .fontWeight(.semibold)
        .frame(maxWidth: .infinity)
        .padding(.top, 44)

      Image(ImageResource.seeWhoSentIt)
        .resizable()
        .aspectRatio(contentMode: .fit)
    }
    .padding(.bottom, 20)
    .padding(.horizontal, 16)
    .multilineTextAlignment(.center)
    .background(Color(uiColor: UIColor.secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .overlay(alignment: .top) {
      Text("Special offer", bundle: .module)
        .font(.title2)
        .bold()
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(
          LinearGradient(
            colors: [
              Color(0xFFFD2D76),
              Color(0xFFFE7056)
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
    SpecialOfferView()
  }
  .environment(\.colorScheme, .dark)
  .environment(\.locale, Locale(identifier: "ja-JP"))
}
