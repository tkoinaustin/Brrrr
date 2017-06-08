//
//  Location.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/25/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

class Location {
  static var geocoder = CLGeocoder()

  static func getCoordinates(_ location: String) -> Promise<[CLPlacemark]> {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    return Promise<[CLPlacemark]> { fulfill, reject in
      self.geocoder.geocodeAddressString(location) { placemarks, error in
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        
        if let error = error { return reject(error) }
        
        if let places = placemarks { return fulfill(places) }
        else { return reject(APIError.geocoder(location: location)) }
      }
    }
  }
}
