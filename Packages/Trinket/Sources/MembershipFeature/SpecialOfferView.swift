import Styleguide
import SwiftUI

public struct SpecialOfferView: View {
  @Environment(\.locale) var locale

  public var body: some View {
    VStack(spacing: 16) {
      Text("Special offer", bundle: .module)
        .font(.system(.title2, weight: .bold))
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(
          LinearGradient(
            colors: [
              Color.black,
              Color.yellow
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
      
      VStack(spacing: 24) {
        Text("See who sent it!", bundle: .module)
          .font(.system(.title2, weight: .bold))

        Image(String(localized: "image-see-who-sent-it", bundle: .module), bundle: .module)
          .resizable()
          .aspectRatio(contentMode: .fit)
      }
    }
    .padding(.top, 36)
    .padding(.horizontal, 16)
    .multilineTextAlignment(.center)
    .background(Color(uiColor: UIColor.secondarySystemBackground))
    .clipShape(RoundedRectangle(cornerRadius: 16))
    .overlay(
      RoundedRectangle(cornerRadius: 16)
        .stroke(Color(uiColor: UIColor.opaqueSeparator), lineWidth: 0.5)
    )
  }
}

#Preview {
  NavigationStack {
    SpecialOfferView()
  }
  .environment(\.colorScheme, .dark)
//  .environment(\.locale, Locale(identifier: "ja-JP"))
}
