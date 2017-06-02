//
//  DailyCell.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class DailyCell: UIView, XibLoadable {
  var ibTag: Int = 4
  
  var data: DataPoint! { didSet {
    tempLabel.text = "\(data.temperatureMax)/\(data.temperatureMin)\u{00B0}F \(data.humidity!)% \(data.dayOfWeek)"
    iconLabel.text = data.icon
    timeLabel.text = "\(DateService.hhmma(data.sunriseTime))/\(DateService.hhmma(data.sunsetTime))"
  }}

  @IBOutlet private weak var tempLabel: UILabel!
  @IBOutlet private weak var iconLabel: UILabel!
  @IBOutlet private weak var timeLabel: UILabel!

  func setup() {
  }
  
  override func awakeAfter(using aDecoder: NSCoder) -> Any? {
    return customAwakeAfter(superAwakeAfter: { return super.awakeAfter(using: aDecoder) })
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    makeIBDesignable()
  }
}
