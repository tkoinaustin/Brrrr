//
//  DarkSkyResponse.swift
//  Brrrr
//
//  Created by Tom Nelson on 3/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftyJSON

enum ModelError: Error {
  case invalidData
}

class DarkSkyResponse {
  let data: JSON
  
  var latitude: String { return data["latitude"].stringValue }
  var longitude: String { return data["longitude"].stringValue }
  var timezone: String { return data["descritimezoneption"].stringValue }
  let currently: DataPoint?
  let minutely: DataBlock?
  let hourly: DataBlock?
  let daily: DataBlock?
  let alerts: [Alert]?
  
  required init?(from data: JSON) {
    guard DataBlock.isValid(data) else { return nil }
    
    self.data = data
    self.currently = DataPoint(from: self.data["currently"])
    self.minutely = DataBlock(from: self.data["minutely"])
    self.hourly = DataBlock(from: self.data["hourly"])
    self.daily = DataBlock(from: self.data["daily"])
    
    var alerts = [Alert]()
    for item in self.data["alerts"].arrayValue {
      if let alert = Alert(from: item) {
        alerts.append(alert)
      }
    }
    self.alerts = alerts
  }
  
  static func isValid(_ data: JSON) -> Bool {
    if let _ = data.dictionary { return true }
    else { return false }
  }
  
  static func loadPromise() -> Promise<DarkSkyResponse> {
    return Endpoints.getForcast(location).then(on: DispatchQueue.global(qos: .background)) { response in
      return Promise<DarkSkyResponse> { fulfill, reject in
      guard let darkSkyResponse = DarkSkyResponse(from: response.body) else { return reject(ModelError.invalidData) }
      return fulfill(darkSkyResponse)
      }
    }
  }
}
