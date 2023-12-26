import UIKit
import ImageIO
import AVFoundation
import MobileCoreServices

func convertMovToGif(movUrl: URL) async throws -> URL {
  let asset = AVAsset(url: movUrl)
  let generator = AVAssetImageGenerator(asset: asset)
  generator.appliesPreferredTrackTransform = true
  
  let duration = try await asset.load(.duration)
  let frameCount = Int(duration.seconds * 10)
  
  var images = [CGImage]()

  for i in 0..<frameCount {
    let cmTime = CMTimeMake(value: Int64(i), timescale: 10)
    let cgImage = try generator.copyCGImage(at: cmTime, actualTime: nil)
    images.append(cgImage)
  }
  
  let gifUrl = FileManager.default.temporaryDirectory.appendingPathComponent("converted.gif")
  guard let destination = CGImageDestinationCreateWithURL(gifUrl as CFURL, UTType.gif.identifier as CFString, images.count, nil) else {
    throw NSError(domain: "com.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to create image destination"])
  }
  
  let gifProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]
  CGImageDestinationSetProperties(destination, gifProperties as CFDictionary)
  
  for image in images {
    let frameProperties = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFDelayTime as String: 0.1]]
    CGImageDestinationAddImage(destination, image, frameProperties as CFDictionary)
  }
  
  guard CGImageDestinationFinalize(destination) else {
    throw NSError(domain: "com.example", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to finalize image destination"])
  }
  
  return gifUrl
}
