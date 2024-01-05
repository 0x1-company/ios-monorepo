import SwiftUI

struct PurchaseAboutView: View {
  var body: some View {
    VStack(spacing: 8) {
      Text("Restore a purchase", bundle: .module)

      Text("Recurring billing. You can cancel at any time. Payment will be charged to your iTunes account and your subscription will auto-renew at $500/week until you cancel in iTunes Store settings. By tapping Unlock, you agree to the Terms of Service and auto-renewal.", bundle: .module)
        .font(.footnote)
        .foregroundStyle(Color.secondary)
    }
    .background()
    .multilineTextAlignment(.center)
  }
}

#Preview {
  PurchaseAboutView()
    .environment(\.colorScheme, .dark)
}
