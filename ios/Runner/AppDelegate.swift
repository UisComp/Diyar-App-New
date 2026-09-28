import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // FlutterAppDelegate is a UNUserNotificationCenterDelegate that fans every
    // callback out to the registered plugins. Without this line the first
    // plugin to register (firebase_messaging) takes the delegate for itself,
    // and flutter_local_notifications never sees `willPresentNotification` or
    // `didReceiveNotificationResponse` — so notifications we post ourselves
    // are invisible in the foreground and tapping one routes nowhere.
    // Must run before GeneratedPluginRegistrant so the plugins see it set.
    UNUserNotificationCenter.current().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // UIScene life cycle (required from iOS 27): the engine is created by the
  // scene, after didFinishLaunching, so plugins are registered here.
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }
}
