import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions:{ 
      [UIApplication.LaunchOptionsKey: Any]?,
      [GMSServices provideAPIKey:@AIzaSyD26EyAImrDoOMn3o6FgmSQjlttxjqmS7U];
      [GeneratedPluginRegistrant registerWithRegistry:self];
    }
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
