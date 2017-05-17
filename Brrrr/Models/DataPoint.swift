//
//  DataPoint.swift
//  Brrrr
//
//  Created by Tom Nelson on 3/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataPoint {
  let data: JSON
  
  var apparentTemperature: String? { return data["apparentTemperature"].string }
  var apparentTemperatureMax: String? { return data["apparentTemperatureMax"].string }
  var apparentTemperatureMaxTime: String? { return data["apparentTemperatureMaxTime"].string }
  var apparentTemperatureMin: String? { return data["apparentTemperatureMin"].string }
  var apparentTemperatureMinTime: String? { return data["apparentTemperatureMinTime"].string }
  var cloudCover: String? { return data["cloudCover", "contentUrl"].string }
  var humidity: String? { return data["humidity"].string }
  var icon: String? { return data["icon"].string }
  var moonPhase: String? { return data["moonPhase"].string }
  var nearestStormBearing: String? { return data["nearestStormBearing"].string }
  var nearestStormDistance: String? { return data["nearestStormDistance"].string }
  var ozone: String? { return data["ozone"].string }
  var precipAccumulation: String? { return data["precipAccumulation"].string }
  var precipIntensity: String? { return data["precipIntensity"].string }
  var precipIntensityMax: String? { return data["precipIntensityMax"].string }
  var precipIntensityMaxTime: String? { return data["precipIntensityMaxTime"].string }
  var precipProbability: String? { return data["precipProbability"].string }
  var precipType: String? { return data["precipType"].string }
  var pressure: String? { return data["pressure"].string }
  var summary: String? { return data["summary"].string }
  var sunriseTime: String? { return data["sunriseTime"].string }
  var sunsetTime: String? { return data["sunsetTime"].string }
  var temperature: String? { return data["temperature"].string }
  var temperatureMax: String? { return data["temperatureMax"].string }
  var temperatureMaxTime: String? { return data["temperatureMaxTime"].string }
  var temperatureMin: String? { return data["temperatureMin"].string }
  var temperatureMinTime: String? { return data["temperatureMinTime"].string }
  var time: String? { return data["time"].string }
  var visibility: String? { return data["visibility"].string }
  var windBearing: String? { return data["windBearing"].string }
  var windSpeed: String? { return data["windSpeed"].string }

  required init?(from data: JSON) {
    self.data = data
  }
}
