import Cocoa
import FlutterMacOS
import Foundation

public class BgPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bg", binaryMessenger: registrar.messenger)
    let instance = BgPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
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
            
            let options: [NSWorkspace.DesktopImageOptionKey: Any] = [.allowClipping: true]
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
