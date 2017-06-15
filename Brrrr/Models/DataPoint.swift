//
//  DataPoint.swift
//  Brrrr
//
//  Created by Tom Nelson on 3/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataPoint {
  let data: JSON
  
  var apparentTemperature: String { return FormatService.tmp(data["apparentTemperature"].numberValue) }
  var apparentTemperatureMax: String { return FormatService.tmp(data["apparentTemperatureMax"].numberValue) }
  var apparentTemperatureMaxTime: Double { return data["apparentTemperatureMaxTime"].doubleValue }
  var apparentTemperatureMin: String { return FormatService.tmp(data["apparentTemperatureMin"].numberValue) }
  var apparentTemperatureMinTime: Double { return data["apparentTemperatureMinTime"].doubleValue }
  var cloudCover: String { return FormatService.pct(data["cloudCover"].numberValue) }
  var dewPoint: String { return FormatService.tmp(data["dewPoint"].numberValue) }
  var humidity: String { return FormatService.pct(data["humidity"].numberValue) }
  var icon: String { return Icon.meaning(data["icon"].stringValue) }
  var moonPhase: String { return FormatService.pct(data["moonPhase"].numberValue) }
  var nearestStormBearing: String? { return data["nearestStormBearing"].string }
  var nearestStormDistance: String? { return data["nearestStormDistance"].string }
  var ozone: String { return FormatService.tmp(data["ozone"].numberValue) }
  var precipAccumulation: String? { return data["precipAccumulation"].string }
  var precipIntensity: String { return data["precipIntensity"].numberValue.description }
  var precipIntensityError: String? { return data["precipIntensityError"].number?.description }
  var precipIntensityMax: String? { return data["precipIntensityMax"].string }
  var precipIntensityMaxTime: String? { return data["precipIntensityMaxTime"].string }
  var precipProbability: String { return FormatService.pct(data["precipProbability"].numberValue) }
  var precipType: String { return data["precipType"].stringValue }
  var pressure: String { return data["pressure"].intValue.description }
  var summary: String { return data["summary"].stringValue }
  var sunriseTime: Double { return data["sunriseTime"].doubleValue }
  var sunsetTime: Double { return data["sunsetTime"].doubleValue }
  var temperature: String { return FormatService.degrees(data["temperature"].numberValue) }
  var temperatureMax: String { return FormatService.tmp(data["temperatureMax"].numberValue) }
  var temperatureMaxTime: Double { return data["temperatureMaxTime"].doubleValue }
  var temperatureMin: String { return FormatService.tmp(data["temperatureMin"].numberValue) }
  var temperatureMinTime: Double { return data["temperatureMinTime"].doubleValue }
  var timeValue: Double? { return data["time"].double }
  var uvIndex: String { return data["uvIndex"].stringValue }
  var visibility: String { return FormatService.tmp(data["visibility"].numberValue) }
  var windBearing: String { return FormatService.tmp(data["windBearing"].numberValue) }
  var windSpeed: String { return FormatService.tmp(data["windSpeed"].numberValue) }
  var time: Date? { return Date(timeIntervalSince1970: data["time"].doubleValue) }
  var prettyDate: String? { return FormatService.ha(data["time"].doubleValue) }
  var dayOfWeek: String { return FormatService.dayOfWeek(data["time"].doubleValue) }
  var longDate: String { return FormatService.longDate(data["time"].doubleValue) }

  required init?(from data: JSON) { //, formatters: [Formatter]) {
    self.data = data
  }
}
