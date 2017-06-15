//
//  Endpoints.swift
//  Brrrr
//
//  Created by Tom Nelson on 3/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import CoreLocation

class Endpoints {
  private enum Endpoints {
    case forecast(location: CLLocation)
    case history(location: CLLocation, date: Date)
    
    func path() -> String {
      switch self {
      case .forecast(location: let location):
        return "/forecast/\(API.apiKey)/\(location.coordinate.latitude),\(location.coordinate.longitude)"
      case .history(location: let location, date: let date):
        return "/forecast/\(API.apiKey)/\(location.coordinate.latitude),\(location.coordinate.longitude),\(date)"
      }
    }
  }
  
  static func getForcast(_ location: CLLocation, completion: @escaping (() -> (APIResponse)) -> Void) {
    let request = APIRequest(.get, path: Endpoints.forecast(location: location).path())
    return API.fire(request, completion: completion)
  }
  
  static func getHistory(_ location: CLLocation, date: Date, completion: @escaping (() -> (APIResponse)) -> Void) {
    let request = APIRequest(.get, path: Endpoints.history(location: location, date: date).path())
    return API.fire(request, completion: completion)
  }
}
