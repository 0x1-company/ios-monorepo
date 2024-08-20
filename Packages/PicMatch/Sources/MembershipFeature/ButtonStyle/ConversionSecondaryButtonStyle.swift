import Styleguide
import SwiftUI

struct ConversionSecondaryButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(.subheadline, design: .rounded, weight: .semibold))
      .frame(height: 50)
      .frame(maxWidth: .infinity)
      .foregroundStyle(Color.black)
      .background(Color.white)
      .clipShape(RoundedRectangle(cornerRadius: 16))
      .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
      .animation(.default, value: configuration.isPressed)
  }
}
