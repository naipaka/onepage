import Flutter
import ImageIO
import UniformTypeIdentifiers

public class NativeImageCompressorPlugin: NSObject, FlutterPlugin {
  private static let errorCode = "native_image_compressor"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "com.naipaka.native_image_compressor",
      binaryMessenger: registrar.messenger()
    )
    registrar.addMethodCallDelegate(NativeImageCompressorPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let arguments = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "size":
      runInBackground(result) {
        let size = try ImageCompressor.size(path: arguments["path"] as? String ?? "")
        return [size.width, size.height]
      }
    case "compress":
      runInBackground(result) {
        let data = try ImageCompressor.compress(
          path: arguments["path"] as? String ?? "",
          width: arguments["width"] as? Int ?? 0,
          height: arguments["height"] as? Int ?? 0,
          format: arguments["format"] as? String ?? "",
          quality: arguments["quality"] as? Int ?? 0
        )
        return FlutterStandardTypedData(bytes: data)
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func runInBackground(_ result: @escaping FlutterResult, task: @escaping () throws -> Any) {
    DispatchQueue.global(qos: .userInitiated).async {
      do {
        let value = try task()
        DispatchQueue.main.async { result(value) }
      } catch {
        DispatchQueue.main.async {
          result(
            FlutterError(
              code: NativeImageCompressorPlugin.errorCode,
              message: error.localizedDescription,
              details: nil
            )
          )
        }
      }
    }
  }
}

struct ImageCompressorError: LocalizedError {
  let errorDescription: String?

  init(_ description: String) {
    errorDescription = description
  }
}

enum ImageCompressor {
  /// Returns the size of the image at `path` after its orientation is applied.
  static func size(path: String) throws -> (width: Int, height: Int) {
    let source = try imageSource(path: path)
    guard
      let properties = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [CFString: Any],
      let width = properties[kCGImagePropertyPixelWidth] as? Int,
      let height = properties[kCGImagePropertyPixelHeight] as? Int
    else {
      throw ImageCompressorError("Cannot read the image at \(path)")
    }
    // Orientations 5 to 8 turn the image a quarter, so the sides swap.
    let orientation = properties[kCGImagePropertyOrientation] as? Int ?? 1
    return orientation >= 5 ? (height, width) : (width, height)
  }

  static func compress(path: String, width: Int, height: Int, format: String, quality: Int) throws -> Data {
    let source = try imageSource(path: path)
    // A thumbnail is decoded at the reduced size and has the orientation applied.
    let options: [CFString: Any] = [
      kCGImageSourceCreateThumbnailFromImageAlways: true,
      kCGImageSourceCreateThumbnailWithTransform: true,
      kCGImageSourceShouldCacheImmediately: true,
      kCGImageSourceThumbnailMaxPixelSize: max(width, height),
    ]
    guard let thumbnail = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary) else {
      throw ImageCompressorError("Cannot read the image at \(path)")
    }
    let image = try resized(thumbnail, width: width, height: height)
    return try encode(image, format: format, quality: quality)
  }

  private static func imageSource(path: String) throws -> CGImageSource {
    let url = URL(fileURLWithPath: path) as CFURL
    guard let source = CGImageSourceCreateWithURL(url, [kCGImageSourceShouldCache: false] as CFDictionary) else {
      throw ImageCompressorError("Cannot open the image at \(path)")
    }
    return source
  }

  // ImageIO rounds the short side of a thumbnail, while `SizeLimit.fit` rounds
  // it down, so the two can differ by a pixel.
  private static func resized(_ image: CGImage, width: Int, height: Int) throws -> CGImage {
    if image.width == width && image.height == height {
      return image
    }
    guard
      let context = CGContext(
        data: nil,
        width: width,
        height: height,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: image.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
      )
    else {
      throw ImageCompressorError("Cannot resize the image")
    }
    context.interpolationQuality = .high
    context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
    guard let resized = context.makeImage() else {
      throw ImageCompressorError("Cannot resize the image")
    }
    return resized
  }

  private static func encode(_ image: CGImage, format: String, quality: Int) throws -> Data {
    let type: UTType = format == "png" ? .png : .jpeg
    let data = NSMutableData()
    guard let destination = CGImageDestinationCreateWithData(data, type.identifier as CFString, 1, nil) else {
      throw ImageCompressorError("Cannot write \(format)")
    }
    let properties: [CFString: Any] = [kCGImageDestinationLossyCompressionQuality: Double(quality) / 100]
    CGImageDestinationAddImage(destination, image, properties as CFDictionary)
    guard CGImageDestinationFinalize(destination) else {
      throw ImageCompressorError("Cannot write \(format)")
    }
    return data as Data
  }
}
