//
//  DailyViewController.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/13/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class DailyViewController: UIViewController {
  
  var data: DataPoint! { didSet {
    print("data: \(data)")
  }}
  var city = ""
  var date = ""
  
  @IBOutlet private weak var cityLabel: UILabel! { didSet {
    cityLabel.text = city
  }}
  @IBOutlet private weak var dateLabel: UILabel! { didSet {
    dateLabel.text = date
  }}

  @IBOutlet private weak var summaryLabel: UILabel! { didSet {
    summaryLabel.text = "\(data.summary)"
    }}

  @IBOutlet private weak var highTempLabel: UILabel! { didSet {
    highTempLabel.text = "\(data.temperatureMax)\u{00B0}F"
  }}
  
  @IBOutlet private weak var highTempTimeLabel: UILabel! { didSet {
      highTempTimeLabel.text = "\(FormatService.hhmma(data.temperatureMaxTime))"
  }}
  
  @IBOutlet private weak var highTempFeelsLikeLabel: UILabel! { didSet {
    highTempFeelsLikeLabel.text = "\(data.apparentTemperatureMax)\u{00B0}F"
  }}

  @IBOutlet private weak var lowTempLabel: UILabel! { didSet {
    lowTempLabel.text = "\(data.temperatureMin)\u{00B0}F"
  }}

  @IBOutlet private weak var lowTempTimeLabel: UILabel! { didSet {
    lowTempTimeLabel.text = "\(FormatService.hhmma(data.temperatureMinTime))"
  }}

  @IBOutlet private weak var lowTempFeelsLikeLabel: UILabel! { didSet {
    lowTempFeelsLikeLabel.text = "\(data.apparentTemperatureMin)\u{00B0}F"
  }}

  @IBOutlet private weak var precipitationLabel: UILabel! { didSet {
    let precip = data.precipType == "" ? "none" : data.precipType
    precipitationLabel.text = "\(precip)"
  }}

  @IBOutlet private weak var probabilityLabel: UILabel! { didSet {
    probabilityLabel.text = "\(data.precipProbability)"
  }}
  
  @IBOutlet private weak var windLabel: UILabel! { didSet {
    windLabel.text = "\(data.windSpeed) mph bearing \(data.windBearing)\u{00B0}"
  }}
  
  @IBOutlet private weak var humidityLabel: UILabel! { didSet {
    humidityLabel.text = "\(data.humidity)"
  }}

  @IBOutlet private weak var visibilityLabel: UILabel! { didSet {
    let miles = data.visibility
    switch miles {
      case "0": visibilityLabel.text = "unlimited"
      case "1": visibilityLabel.text = "1 mile"
    default: visibilityLabel.text = "\(miles) miles"
    }
  }}

  @IBOutlet private weak var sunriseLabel: UILabel! { didSet {
    sunriseLabel.text = "\(FormatService.hhmma(data.sunriseTime))"
  }}
  
  @IBOutlet private weak var sunsetLabel: UILabel! { didSet {
    sunsetLabel.text = "\(FormatService.hhmma(data.sunsetTime))"
  }}
  
  @IBOutlet private weak var lunarLabel: UILabel! { didSet {
    lunarLabel.text = "\(data.moonPhase)"
  }}

  @IBOutlet private weak var dewPointLabel: UILabel! { didSet {
    dewPointLabel.text = "\(data.dewPoint)\u{00B0}F"
  }}

  @IBOutlet private weak var cloudCoverLabel: UILabel! { didSet {
    cloudCoverLabel.text = "\(data.cloudCover)"
  }}
  
  @IBOutlet private weak var barometerLabel: UILabel! { didSet {
    barometerLabel.text = "\(data.pressure) mmHg"
  }}

  @IBOutlet private weak var ozoneLabel: UILabel! { didSet {
    ozoneLabel.text = "\(data.ozone)"
  }}
  
  @IBOutlet private weak var uvIndexLabel: UILabel! { didSet {
    uvIndexLabel.text = "\(data.uvIndex)"
  }}
  
  @IBAction func backAction(_ sender: UIButton) {
    _ = navigationController?.popViewController(animated: true)
  }

//   "windSpeed" : 5.12,
//   "pressure" : 1006.57,
//   "summary" : "Rain in the morning.",
//   "sunsetTime" : 1497491964,
//   "apparentTemperatureMaxTime" : 1497477600,
//   "moonPhase" : 0.66,
//   "sunriseTime" : 1497437489,
//   "temperatureMin" : 69.97,
//   "apparentTemperatureMinTime" : 1497438000,
//   "visibility" : 10,
//   "temperatureMinTime" : 1497438000,
//   "apparentTemperatureMin" : 69.63,
//   "humidity" : 0.63,
//   "dewPoint" : 63.92,
//   "precipType" : "rain",
//   "windBearing" : 212,
//   "cloudCover" : 0.34,
//   "ozone" : 314.69,
//   "precipProbability" : 0.45,
//   "temperatureMax" : 88.88,
//   "temperatureMaxTime" : 1497477600,
//   "apparentTemperatureMax" : 88.40000000000001
 
}
