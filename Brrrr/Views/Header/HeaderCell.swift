//
//  HeaderCell.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/6/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

let inset: CGFloat = 120

class HeaderCell: UIView, XibLoadable {
  var ibTag: Int = 43
  var data: DataPoint! { didSet {
    guard data != nil else { return }
    forecastLabel.text = "\(data.summary)"
    tempLabel.text = "\(data.temperature)"
    if data.data.dictionaryValue.isEmpty {
      tempLabel.text = ""
      cityLabel.text = ""
    }
  }}
  var offset: CGFloat = -inset { didSet {
//    print("offset is \(offset)")
    var cityScale: CGFloat = 1
    var tempScale: CGFloat = 1
    var tempTrans: CGFloat = 0
    if offset < 0 {
      cityScale = (max(offset, -50) - 50) / (-100)
      self.tempLabel.alpha = max((-75.0 - offset)/(inset - 75.0), 0)
    } else {
      cityScale = 0.5
      self.tempLabel.alpha = 0.0
    }
    self.cityLabel.transform = CGAffineTransform.init(scaleX: cityScale, y: cityScale)
    self.cityLabelConstraint.constant = 20 * cityScale * cityScale
    self.forecastLabelConstraint.constant = 8 * cityScale * cityScale
    
    if offset < -inset {
      tempScale = 1 + (-inset - offset) / 220
      tempTrans = (-inset - offset) / 3
    } else if offset < -75 {
      tempScale = 1 + (-inset - offset) / inset
      tempTrans = (-inset - offset) / 2
    }
    self.tempLabel.transform = CGAffineTransform.init(scaleX: tempScale, y: tempScale)
      .translatedBy(x: 0, y: tempTrans)
  }}
  //swiftlint:disable private_outlet
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet private weak var forecastLabel: UILabel!
  @IBOutlet private weak var tempLabel: UILabel!
  @IBOutlet private weak var cityLabelConstraint: NSLayoutConstraint!
  @IBOutlet private weak var forecastLabelConstraint: NSLayoutConstraint!
  
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
