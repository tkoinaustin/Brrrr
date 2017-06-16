//
//  Location.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/25/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import CoreLocation

typealias PlacemarkBuilder = () throws -> [CLPlacemark]

class Location: NSObject {
  static var geocoder = CLGeocoder()
  static var shared = Location()
  let manager = CLLocationManager()
  var updateUI: (CLLocation) -> Void = { _ in }
  
  func getCurrentCoordinates() {
    self.manager.delegate = self
    self.manager.desiredAccuracy = kCLLocationAccuracyKilometer
    
    let status = CLLocationManager.authorizationStatus()
    print("authorizationStatus is \(status)")
    switch status {
    case .denied, .restricted: return
    case .notDetermined: self.manager.requestWhenInUseAuthorization()
    case .authorizedAlways, .authorizedWhenInUse: self.manager.requestLocation()
    }
  }

  static func getCoordinates(_ location: String, completion: @escaping (PlacemarkBuilder) -> Void) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    self.geocoder.geocodeAddressString(location) { placemarks, error -> Void in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      completion({ _ in
        if error != nil { throw APIError.geocoder(location: location) }
        if let places = placemarks { return places }
        else { throw APIError.geocoder(location: location) }
      })
    }
  }
}

extension Location: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[0]
    print("didUpdateLocations to \(location)")
    self.updateUI(location)
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("didChangeAuthorization to \(status)")
    if status == .authorizedWhenInUse {
      self.manager.requestLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("locationManager failed with error")
  }
}
