import AppKit
import Cocoa
import FlutterMacOS
import Foundation

/// Extension to NSColor to allow for hex colors
extension NSColor {
    /// Creates a color from a hex string.
    convenience init?(hex: String) {
        // Remove any whitespace or newline characters from the string
        let trimmedString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        // Remove the "#" character from the string
        let hexString = trimmedString.replacingOccurrences(of: "#", with: "")

        // Convert the hex string to a UInt64
        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        // Extract the red, green, and blue components from the hex value
        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)

        // Initialize the NSColor object with the extracted color components
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

public class BgPlugin: NSObject, FlutterPlugin {
  // This method is called when the plugin is registered with the Flutter engine.
  public static func register(with registrar: FlutterPluginRegistrar) {
    // Create a new method channel for the plugin
    let channel = FlutterMethodChannel(name: "bg", binaryMessenger: registrar.messenger)
    let instance = BgPlugin()
     // Register the plugin as a delegate for the method channel
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  // Handles Flutter method calls
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let urlString: String? = (call.arguments as? [String: Any])?["url"] as? String

      switch call.method {
      case "changeWallpaper":
          // Ensure the URL is valid
          guard let unwrappedURLString = urlString,
                let url = URL.init(string: unwrappedURLString) else {
              result(invalidURLError(urlString))
              return
          }

          let session = URLSession(configuration: .default)
          let task = session.downloadTask(with: url) { (location, response, error) in
              // Ensure the downloaded location is valid
              guard let location = location else {
                  result(FlutterError(code: "download_error", message: "Failed to download image", details: error?.localizedDescription))
                  return
              }

              let fileManager = FileManager.default
              let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
              let destinationURL = documentsDirectory.appendingPathComponent(url.lastPathComponent)

              do {
                  // Delete the file if it already exists
                  if fileManager.fileExists(atPath: destinationURL.path) {
                      try fileManager.removeItem(at: destinationURL)
                  }

                  // Move the downloaded file to the destination
                  try fileManager.moveItem(at: location, to: destinationURL)
                  let options = self.getOptions(call)

                  // Set the desktop wallpaper
                  try NSWorkspace.shared.setDesktopImageURL(destinationURL, for: NSScreen.main!, options: options)
                  result("success")
              } catch {
                  result(FlutterError(code: "move_file_error", message: error.localizedDescription, details: nil))
              }
          }

          task.resume()
      default:
          result(FlutterMethodNotImplemented)
      }
  }

  // Returns the options for setting the desktop wallpaper
  public func getOptions(_ call: FlutterMethodCall) -> [NSWorkspace.DesktopImageOptionKey: Any] {
      let opts: [String: Any] = (call.arguments as? [String: Any]) ?? [:]
      var options: [NSWorkspace.DesktopImageOptionKey: Any] = [:]

      let scaleString: String = opts["scale"] as! String

      // Determine the image scaling based on the input
      var imageScaling: NSImageScaling = .scaleProportionallyUpOrDown // Default to fit
      if scaleString == "fill" {
          imageScaling = .scaleAxesIndependently
      } else if scaleString == "fit" {
          imageScaling = .scaleProportionallyUpOrDown
      } else if scaleString == "stretch" {
          imageScaling = .scaleAxesIndependently
      } else if scaleString == "center" {
          imageScaling = .scaleNone
      }
      // We don't support tile yet, because not all the images
      // play nicely with this, and MacOS itself doesn't always show the option
      // here's a short snippet of what might work
      // let image = NSImage(named: "background") // Replace with the actual image name
      // let color = NSColor(patternImage: image!)
      // view.layer?.backgroundColor = color.cgColor

      options[.imageScaling] = NSNumber(value: imageScaling.rawValue)

      // Determine the fill color based on the input
      let hexString: String = opts["color"] as? String ?? "#000000"
      options[.fillColor] = NSColor(hex: hexString) ?? NSColor.black

      return options
  }
}

/// Returns an error for the case where a URL string can't be parsed as a URL.
private func invalidURLError(_ url: String?) -> FlutterError {
  return FlutterError(
    code: "argument_error",
    message: "Unable to parse URL",
    details: "Provided URL: \(String(describing: url))")
}
