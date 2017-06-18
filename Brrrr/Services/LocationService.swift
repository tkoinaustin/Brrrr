//
//  LocationService.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/25/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import CoreLocation

typealias PlacemarkBuilder = () throws -> [CLPlacemark]

class LocationService: NSObject {
  static var shared = LocationService()
  var geocoder = CLGeocoder()
  let manager = CLLocationManager()
  var updateUI: (CLLocation) -> Void = { _ in }
  var updatePlace: (CLPlacemark) -> Void = { _ in }
  
  func getCurrentCoordinates() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
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

  func getCoordinates(_ location: String, completion: @escaping (PlacemarkBuilder) -> Void) {
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

extension LocationService: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let location = locations[0]
    self.geocoder.reverseGeocodeLocation(location) { placemarks, _ in
      self.updatePlace((placemarks?[0])!)
      DispatchQueue.main.async {
        self.updateUI(location)
      }
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("didChangeAuthorization to \(status.hashValue)")
    if status == .authorizedWhenInUse {
      self.manager.requestLocation()
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    print("locationManager failed with error")
  }
}
