public struct ButtonClickKeys: Sendable {}

private var buttonClickKeys = ButtonClickKeys()

public extension AnalyticsClient {
  func buttonClick(name keyPath: KeyPath<ButtonClickKeys, String>, parameters: [String: Any] = [:]) {
    var parameters = parameters
    parameters["name"] = buttonClickKeys[keyPath: keyPath]
    logEvent("button_click", parameters)
  }
}
