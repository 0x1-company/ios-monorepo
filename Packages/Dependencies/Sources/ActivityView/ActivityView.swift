import SwiftUI

public struct ActivityView: UIViewControllerRepresentable {
  public typealias UIViewControllerType = UIActivityViewController

  let activityViewController: UIActivityViewController

  public init(
    activityItemsConfiguration: UIActivityItemsConfigurationReading,
    completionWithItemsHandler: UIActivityViewController.CompletionWithItemsHandler?
  ) {
    let activityViewController = UIActivityViewController(activityItemsConfiguration: activityItemsConfiguration)
    activityViewController.completionWithItemsHandler = completionWithItemsHandler
    self.activityViewController = activityViewController
  }

  public init(
    activityItems: [Any],
    applicationActivities: [UIActivity]?,
    completionWithItemsHandler: UIActivityViewController.CompletionWithItemsHandler?
  ) {
    let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    activityViewController.completionWithItemsHandler = completionWithItemsHandler
    self.activityViewController = activityViewController
  }

  public func makeUIViewController(context _: Context) -> UIActivityViewController {
    activityViewController
  }

  public func updateUIViewController(_: UIActivityViewController, context _: Context) {}
}

#Preview {
  Color.clear
    .sheet(isPresented: .constant(true)) {
      ActivityView(
        activityItems: [
          "tomokisun",
        ],
        applicationActivities: nil
      ) { _, _, _, _ in
      }
      .presentationDetents([.medium, .large])
    }
}
