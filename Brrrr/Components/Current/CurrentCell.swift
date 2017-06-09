//
//  CurrentCell.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/7/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class CurrentCell: UITableViewCell {
  var data: DataPoint! { didSet {
    labelsView.isHidden = data.data.isEmpty
    dataView.isHidden = data.data.isEmpty
    temperatureLabel.text = "\(data.temperature)\u{00B0}F"
    humidityLabel.text = "\(data.humidity)"
    windLabel.text = "\(data.windSpeed) mph bearing \(data.windBearing)\u{00B0}"
    feelsLikeLabel.text = "\(data.apparentTemperature)\u{00B0}F"
    visibilityLabel.text = "\(data.visibility) miles"
    barometricLabel.text = "\(data.pressure) mmHg"
    }}
  
  @IBOutlet private weak var labelsView: UIView!
  @IBOutlet private weak var dataView: UIView!
  @IBOutlet private weak var temperatureLabel: UILabel!
  @IBOutlet private weak var humidityLabel: UILabel!
  @IBOutlet private weak var windLabel: UILabel!
  @IBOutlet private weak var feelsLikeLabel: UILabel!
  @IBOutlet private weak var visibilityLabel: UILabel!
  @IBOutlet private weak var barometricLabel: UILabel!
}
