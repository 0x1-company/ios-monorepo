
import SwiftUI

struct ConversionPrimaryButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(.subheadline, weight: .semibold))
      .frame(height: 50)
      .frame(maxWidth: .infinity)
      .foregroundStyle(Color.black)
      .background(
        LinearGradient(
          colors: [
            Color(0xFFE8_B423),
            Color(0xFFF5_D068),
          ],
          startPoint: .leading,
          endPoint: .trailing
        )
      )
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
      .animation(.default, value: configuration.isPressed)
  }
}
