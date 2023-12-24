import SwiftUI

public struct HoldDownButtonStyle: ButtonStyle {
  public init() {}

  public func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
      .animation(.default, value: configuration.isPressed)
  }
}
