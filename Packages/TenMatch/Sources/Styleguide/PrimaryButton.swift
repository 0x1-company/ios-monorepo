import SwiftUI

public struct PrimaryButton: View {
  let title: String
  let isLoading: Bool
  let isDisabled: Bool
  let action: () -> Void

  public init(
    _ title: String,
    isLoading: Bool = false,
    isDisabled: Bool = false,
    action: @escaping () -> Void
  ) {
    self.title = title
    self.isLoading = isLoading
    self.isDisabled = isDisabled
    self.action = action
  }

  public var body: some View {
    Button(action: action) {
      Group {
        if isLoading {
          ProgressView()
            .progressViewStyle(.circular)
            .tint(Color.black)
        } else {
          Text(title)
        }
      }
      .font(.system(.subheadline, design: .rounded, weight: .semibold))
      .frame(height: 50)
      .frame(maxWidth: .infinity)
      .foregroundStyle(
        isLoading || isDisabled
          ? Color(uiColor: UIColor.quaternaryLabel)
          : Color.black
      )
      .background(
        isLoading || isDisabled
          ? Color(uiColor: UIColor.secondarySystemBackground)
          : Color.white
      )
      .cornerRadius(16)
    }
    .disabled(isLoading || isDisabled)
    .buttonStyle(HoldDownButtonStyle())
  }
}
