import UIKit
import Flutter
import CoreLocation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate, CLLocationManagerDelegate {
  var locationManager = CLLocationManager()
  var locationResult: FlutterResult?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController
    let locationChannel = FlutterMethodChannel(name: "com.example/location",
                                              binaryMessenger: controller.binaryMessenger)

    locationChannel.setMethodCallHandler { (call, result) in
      if call.method == "getCurrentLocation" {
        self.locationResult = result
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    locationResult?(["latitude": location.coordinate.latitude,
                     "longitude": location.coordinate.longitude])
    locationManager.stopUpdatingLocation()
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    locationResult?(FlutterError(code: "UNAVAILABLE", message: "Location not available", details: nil))
  }
}
