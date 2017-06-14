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
  @IBOutlet weak var dateLabel: UILabel! { didSet {
    dateLabel.text = date
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
