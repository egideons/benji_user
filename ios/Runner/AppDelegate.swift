import UIKit
import Flutter
import awesome_notifications
import shared_preferences_foundation
import GoogleMaps
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      GeneratedPluginRegistrant.register(with: self)

      // Google Maps API Key
      GMSServices.provideAPIKey("AIzaSyABRQIbm3Dl4x8TKq_6Ht3PaNllH_8yuwo")

      // This function registers the desired plugins to be used within a notification background action
      SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
          SwiftAwesomeNotificationsPlugin.register(
            with: registry.registrar(forPlugin: "io.flutter.plugins.awesomenotifications.AwesomeNotificationsPlugin")!)
          SharedPreferencesPlugin.register(
            with: registry.registrar(forPlugin: "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin")!)
      }

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
