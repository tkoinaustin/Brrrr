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
  @IBOutlet weak var cityLabel: UILabel!
  @IBOutlet private weak var forecastLabel: UILabel!
  @IBOutlet weak var tempLabel: UILabel!
  
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
