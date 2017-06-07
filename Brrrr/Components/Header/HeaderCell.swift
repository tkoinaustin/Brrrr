//
//  HeaderCell.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/6/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class HeaderCell: UIView, XibLoadable {
  var ibTag: Int = 43
  var data: DataPoint! { didSet {
    guard data != nil else { return }
    forecastLabel.text = "\(data.summary)"
    tempLabel.text = "\(data.temperature)\u{00B0}"
    }}
  
  var offset: CGFloat = -120 { didSet {
    var scale: CGFloat = 1.0
    if offset < 0 {
      scale = (max(offset, -50) - 50) / (-100)
      self.tempLabel.alpha = max((-75.0 - offset)/75.0, 0)
    } else {
      scale = 0.5
      self.tempLabel.alpha = 0.0
    }
    self.cityLabel.transform = CGAffineTransform.init(scaleX: scale, y: scale)
    self.cityLabelConstraint.constant = 20 * scale * scale
    self.forecastLabelConstraint.constant = 8 * scale * scale
  }}
  
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
