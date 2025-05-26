import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // Flavor method channel
    let controller = self.window.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel.init(name: "flavor", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { (call, result) in
        let flavor = Bundle.main.infoDictionary?["Flavor"]
        result(flavor!)
    }
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
