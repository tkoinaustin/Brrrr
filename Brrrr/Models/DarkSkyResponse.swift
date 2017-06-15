//
//  DarkSkyResponse.swift
//  Brrrr
//
//  Created by Tom Nelson on 3/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

enum ModelError: Error {
  case invalidData
}

class DarkSkyResponse {
  let data: JSON
  
  var latitude: String { return data["latitude"].stringValue }
  var longitude: String { return data["longitude"].stringValue }
  var timezone: String { return data["timezone"].stringValue }
  let currently: DataPoint?
  let minutely: DataBlock?
  let hourly: DataBlock?
  let daily: DataBlock?
  let alerts: [Alert]?
  var locale: Locale!
  let dateFormatter = DateFormatter()
  let tempFormatter = NumberFormatter()
  
  static let empty = DarkSkyResponse(from: ["empty": "response"])
  
  required init?(from data: JSON) {
    guard DataBlock.isValid(data) else { return nil }
    
    self.data = data
    
    self.locale = Locale(identifier: data["timezone"].stringValue)
    FormatService.timezone = TimeZone(identifier: data["timezone"].stringValue)
    
    self.dateFormatter.dateFormat = "ha"
    self.dateFormatter.locale = self.locale
    
    self.tempFormatter.maximumFractionDigits = 0
    
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
    if data.dictionary != nil { return true }
    else { return false }
  }
  
  static func loadWeather(_ location: CLLocation, closure: @escaping ((DarkSkyResponse?, APIError?) -> Void)) -> Void {
    return Endpoints.getForcast(location) { response in
      if let error = response().error {
        closure(nil, error)
      }
      else if let darkSkyResponse = DarkSkyResponse(from: response().body!) {
        closure(darkSkyResponse, nil)
      }
      else {
        closure(nil, APIError.body)
      }
    }
  }
}
