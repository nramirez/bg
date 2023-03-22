import AppKit
import Cocoa
import FlutterMacOS
import Foundation

extension NSColor {
  /// Creates a color from a hex string.
    convenience init?(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var rgbValue: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0
        let alpha = CGFloat(1.0)

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}


public class BgPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bg", binaryMessenger: registrar.messenger)
    let instance = BgPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public enum Scale {
		case auto
		case fill
		case fit
		case stretch
		case center
	}

  // Fill Screen,  Stretch to Fill Screen, Center, Fit to Screen,
  // Center and Fit to Screen receive colors
  public func getOptions(_ call: FlutterMethodCall) -> [NSWorkspace.DesktopImageOptionKey: Any]{
    let opts: [String: Any] = (call.arguments as? [String: Any]) ?? [:]
    var options: [NSWorkspace.DesktopImageOptionKey: Any] = [:]

    let scaleString: String = opts["scale"] as! String
    
    if scaleString == "fill" {
       options[.imageScaling] = NSNumber(value: NSImageScaling.scaleAxesIndependently.rawValue)
    } else if scaleString == "fit" {
        options[.imageScaling] = NSNumber(value:NSImageScaling.scaleProportionallyUpOrDown.rawValue)
    } else if scaleString == "stretch" {
        options[.imageScaling] = NSNumber(value:NSImageScaling.scaleAxesIndependently.rawValue)
    } else if scaleString == "center" {
        options[.imageScaling] = NSNumber(value:NSImageScaling.scaleNone.rawValue)
    } else {
      // default to auto
        options[.imageScaling] = NSNumber(value:NSImageScaling.scaleProportionallyUpOrDown.rawValue)
    }

    let hexString: String = opts["color"] as? String ?? "#000000"
    options[.fillColor] = NSColor(hex: hexString) ?? NSColor.black

    return options
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let urlString: String? = (call.arguments as? [String: Any])?["url"] as? String


    switch call.method {
      case "changeWallpaper":
       guard let unwrappedURLString = urlString,
            let url = URL.init(string: unwrappedURLString)
        else {
          result(invalidURLError(urlString))
          return
        }
        

    let session = URLSession(configuration: .default)
    let task = session.downloadTask(with: url) { (location, response, error) in
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
            
            try fileManager.moveItem(at: location, to: destinationURL)
            let options = self.getOptions(call)
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
}

/// Returns an error for the case where a URL string can't be parsed as a URL.
private func invalidURLError(_ url: String?) -> FlutterError {
  return FlutterError(
    code: "argument_error",
    message: "Unable to parse URL",
    details: "Provided URL: \(String(describing: url))")
}
