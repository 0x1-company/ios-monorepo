import SwiftUI

struct CALayerView: UIViewControllerRepresentable {
  var caLayer: CALayer

  func makeUIViewController(context: Context) -> UIViewController {
    let viewController = UIViewController()
    viewController.view.layer.addSublayer(caLayer)
    caLayer.frame = viewController.view.layer.frame
    return viewController
  }

  func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    caLayer.frame = uiViewController.view.layer.frame
  }
}
