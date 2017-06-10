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

class Location {
  static var geocoder = CLGeocoder()

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
