//
//  Endpoints.swift
//  Brrrr
//
//  Created by Tom Nelson on 3/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import PromiseKit

class Endpoints {
  private enum Endpoints {
    case forecast(location: String)
    case history(location: String, date: Date)
    
    func path() -> String {
      switch self {
      case .forecast(location: let location): return "/forecast/\(darkskySecret)/\(location)"
      case .history(location: let location, date: let date): return "/forecast/\(darkskySecret)/\(location),\(date)"
      }
    }
  }
  
  static func getForcast(_ location: String) -> Promise<APIResponse> {
    let request = APIRequest(.get, path: Endpoints.forecast(location: location).path())
    return API.fire(request)
  }
  
  static func getHistory(_ location: String, date: Date) -> Promise<APIResponse> {
    let request = APIRequest(.get, path: Endpoints.history(location: location, date: date).path())
    return API.fire(request)
  }
}
