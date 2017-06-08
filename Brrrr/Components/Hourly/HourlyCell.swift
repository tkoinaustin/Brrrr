//
//  HourlyCell.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/31/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class HourlyCell: UICollectionViewCell {
  static let Identifier = "HourlyCell"

  @IBOutlet private weak var temperature: UILabel!
  @IBOutlet private weak var icon: UILabel!
  @IBOutlet private weak var date: UILabel!
  
  func load(_ data: DataPoint) {
    self.temperature.text = "\(data.temperature)F"
    self.icon.text = "\(data.icon)"
    self.date.text = "\(String(describing: data.prettyDate!))"
  }
}
