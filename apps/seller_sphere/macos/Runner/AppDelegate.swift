import Cocoa
import FlutterMacOS
import GoogleMaps

@main
class AppDelegate: FlutterAppDelegate {
  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    // Ambil API Key dari environment variable yang di-pass via --dart-define
    if let googleMapsApiKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String {
        GMSServices.provideAPIKey(googleMapsApiKey)
    } else {
        print("ERROR: GOOGLE_MAPS_API_KEY not found in Info.plist")
    }

    super.applicationDidFinishLaunching(Notification(name: NSApplication.didFinishLaunchingNotification))
    return true
  }
}
