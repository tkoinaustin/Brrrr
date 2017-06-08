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
  let dateFormatter: DateFormatter!
  let tempFormatter: NumberFormatter!
  
  var apparentTemperature: String { return tempFormatter.string(from: data["apparentTemperature"].numberValue)! }
  var apparentTemperatureMax: NSNumber { return data["apparentTemperatureMax"].numberValue }
  var apparentTemperatureMaxTime: NSNumber { return data["apparentTemperatureMaxTime"].numberValue }
  var apparentTemperatureMin: NSNumber { return data["apparentTemperatureMin"].numberValue }
  var apparentTemperatureMinTime: NSNumber { return data["apparentTemperatureMinTime"].numberValue }
  var cloudCover: String { return FormatService.percent(data["cloudCover"].numberValue) }
  var humidity: String { return FormatService.percent(data["humidity"].numberValue) }
  var icon: String { return Icon.meaning(data["icon"].stringValue) }
  var moonPhase: String? { return data["moonPhase"].string }
  var nearestStormBearing: String? { return data["nearestStormBearing"].string }
  var nearestStormDistance: String? { return data["nearestStormDistance"].string }
  var ozone: String? { return data["ozone"].string }
  var precipAccumulation: String? { return data["precipAccumulation"].string }
  var precipIntensity: String { return data["precipIntensity"].numberValue.description }
  var precipIntensityError: String? { return data["precipIntensityError"].number?.description }
  var precipIntensityMax: String? { return data["precipIntensityMax"].string }
  var precipIntensityMaxTime: String? { return data["precipIntensityMaxTime"].string }
  var precipProbability: String { return data["precipProbability"].numberValue.description }
  var precipType: String? { return data["precipType"].string }
  var pressure: String { return data["pressure"].intValue.description }
  var summary: String { return data["summary"].stringValue }
  var sunriseTime: Double { return data["sunriseTime"].doubleValue }
  var sunsetTime: Double { return data["sunsetTime"].doubleValue }
  var temperature: String { return FormatService.degrees(data["temperature"].numberValue) }
  var temperatureMax: String { return tempFormatter.string(from: data["temperatureMax"].numberValue)! }
  var temperatureMaxTime: String? { return data["temperatureMaxTime"].string }
  var temperatureMin: String { return tempFormatter.string(from: data["temperatureMin"].numberValue)! }
  var temperatureMinTime: String? { return data["temperatureMinTime"].string }
  var timeValue: Double? { return data["time"].double }
  var visibility: String? { return tempFormatter.string(from: data["visibility"].numberValue) }
  var windBearing: String { return data["windBearing"].stringValue }
  var windSpeed: String { return data["windSpeed"].numberValue.description }
  var time: Date? { return Date(timeIntervalSince1970: data["time"].doubleValue) }
  var prettyDate: String? { return FormatService.ha(data["time"].doubleValue) }
  var dayOfWeek: String { return FormatService.dayOfWeek(data["time"].doubleValue) }

  required init?(from data: JSON, formatters: [Formatter]) {
    guard let dateFormatter = formatters[0] as? DateFormatter else { return nil }
    guard let tempFormatter = formatters[1] as? NumberFormatter else { return nil }
    self.dateFormatter = dateFormatter
    self.tempFormatter = tempFormatter
    self.data = data
  }
}
