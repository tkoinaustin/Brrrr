//
//  DailyTableCell.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/6/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class DailyTableCell: UITableViewCell {
  
  var data: DataPoint! { didSet {
    tempLabel.text = "\(data.temperatureMax)/\(data.temperatureMin)\u{00B0}F \(data.humidity) \(data.dayOfWeek)"
    iconLabel.text = data.icon
    timeLabel.text = "\(FormatService.hhmma(data.sunriseTime))/\(FormatService.hhmma(data.sunsetTime))"
    }}
  
  @IBOutlet private weak var tempLabel: UILabel!
  @IBOutlet private weak var iconLabel: UILabel!
  @IBOutlet private weak var timeLabel: UILabel!
}
