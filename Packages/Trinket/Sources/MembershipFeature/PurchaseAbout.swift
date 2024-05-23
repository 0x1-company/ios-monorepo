import SwiftUI

struct PurchaseAboutView: View {
  let displayPrice: String

  var body: some View {
    VStack(spacing: 8) {
      Text("Recurring billing. You can cancel at any time. Payment will be charged to your iTunes account and your subscription will auto-renew at \(displayPrice)/week until you cancel in iTunes Store settings. By tapping Unlock, you agree to the Terms of Service and auto-renewal.", bundle: .module)
        .font(.caption)
        .foregroundStyle(Color(uiColor: UIColor.tertiaryLabel))
    }
    .background()
    .multilineTextAlignment(.center)
  }
}

#Preview {
  PurchaseAboutView(
    displayPrice: "$2.99"
  )
  .environment(\.colorScheme, .dark)
}
