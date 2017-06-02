//
//  Location.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/25/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class Location {
  static var geocoder = CLGeocoder()

  static func getCoordinates(_ location: String) -> Observable<[CLPlacemark]> {
    print("getCoordinates")
    return Observable<[CLPlacemark]>.create { observer in
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      self.geocoder.geocodeAddressString(location) { placemarks, error in
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        guard error == nil else {
          observer.onError(error!)
          return
        }
        if let places = placemarks {
          print("places = \(places)")
          observer.onNext(places)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }

}
