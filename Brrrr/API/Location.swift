//
//  Location.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/25/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class Location {
  static var geocoder = CLGeocoder()

  static func getCoordinates(_ location: String, closure: @escaping (([CLPlacemark], APIError?) -> Void)) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    self.geocoder.geocodeAddressString(location) { placemarks, error in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      if error != nil { closure([CLPlacemark](), APIError.geocoder(location: location)) }
      else {
        if let places = placemarks { closure(places, nil)
        } else {
          closure([CLPlacemark](), APIError.geocoder(location: location))
        }
      }
    }
  }
}
