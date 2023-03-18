import Flutter
import UIKit


public class BgPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "bg", binaryMessenger: registrar.messenger())
    let instance = BgPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
  switch call.method {
  case "changeWallpaper":
    guard let arguments = call.arguments as? Dictionary<String, Any>,
        let urlString = arguments["url"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENT",
                             message: "Invalid arguments provided to changeWallpaper method.",
                             details: nil))
        return
    }

    changeWallpaper(urlString, result: result)
    
    // if let arguments = call.arguments as? Dictionary<String, Any>,
    //    let urlString = arguments["url"] as? String,
    //    let url = URL(string: urlString) {
      
    //   // Download the image from the URL
    //   URLSession.shared.dataTask(with: url) { (data, response, error) in
    //     guard let imageData = data else {
    //       result(FlutterError(code: "INVALID_IMAGE_DATA",
    //                            message: "Failed to download image data from URL.",
    //                            details: nil))
    //       return
    //     }
        
    //     // Save the image to the user's documents directory
    //     let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    //     let imagePath = documentsDirectory.appendingPathComponent("wallpaper.png")
    //     do {
    //       try imageData.write(to: imagePath)
    //     } catch {
    //       result(FlutterError(code: "WRITE_IMAGE_ERROR",
    //                            message: "Failed to write image data to file.",
    //                            details: nil))
    //       return
    //     }
        
    //     // Load the image from the file URL
    //     guard let image = UIImage(contentsOfFile: imagePath.path) else {
    //       result(FlutterError(code: "INVALID_IMAGE_FILE",
    //                            message: "Failed to load image from file.",
    //                            details: nil))
    //       return
    //     }
        
    //     // Set the image as the wallpaper
    //     if !UIAccessibility.isReduceTransparencyEnabled {
    //       let blurEffect = UIBlurEffect(style: .regular)
    //       let blurEffectView = UIVisualEffectView(effect: blurEffect)
    //       blurEffectView.frame = UIScreen.main.bounds
    //       blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //       UIApplication.shared.keyWindow?.addSubview(blurEffectView)
    //     }
    //     UIApplication.shared.keyWindow?.backgroundColor = UIColor(patternImage: image)
        
    //     // Return success
    //     result("success")
    //   }.resume()
      
    // } else {
    //   result(FlutterError(code: "INVALID_ARGUMENT",
    //                        message: "Invalid arguments provided to changeWallpaper method.",
    //                        details: nil))
    // }
    
  default:
    result(FlutterMethodNotImplemented)
  }
}

public func changeWallpaper(_ urlString: String, result: @escaping FlutterResult) {
    guard let url = URL(string: urlString) else {
        result(FlutterError(code: "INVALID_ARGUMENT",
                             message: "Invalid URL provided to changeWallpaper method.",
                             details: nil))
        return
    }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard let imageData = data else {
            result(FlutterError(code: "INVALID_IMAGE_DATA",
                                 message: "Failed to download image data from URL.",
                                 details: nil))
            return
        }
        
        let image = UIImage(data: imageData)
        
        guard let cgImage = image?.cgImage else {
            result(FlutterError(code: "INVALID_IMAGE_DATA",
                                 message: "Failed to convert image data to CGImage.",
                                 details: nil))
            return
        }
        
        let wallpaper = UIImage(cgImage: cgImage, scale: 1.0, orientation: .up)
        
        DispatchQueue.main.async {
            let viewController = UIApplication.shared.windows.first?.rootViewController
            let imageView = UIImageView(frame: viewController?.view.bounds ?? CGRect.zero)
            imageView.contentMode = .scaleAspectFill
            imageView.image = wallpaper
            
            // Add the image view to the view hierarchy
            viewController?.view.addSubview(imageView)
            viewController?.view.sendSubviewToBack(imageView)
            
            // Return success
            result("success")
        }
        
    }.resume()
}


}
