import Styleguide
import SwiftUI

struct ConversionPrimaryButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .font(.system(.subheadline, weight: .semibold))
      .frame(height: 48)
      .frame(maxWidth: .infinity)
      .foregroundStyle(Color.black)
      .background(Color.yellow)
      .clipShape(RoundedRectangle(cornerRadius: 12))
      .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
      .animation(.default, value: configuration.isPressed)
  }
}
