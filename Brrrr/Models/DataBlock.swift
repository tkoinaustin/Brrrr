//
//  DataBlock.swift
//  Brrrr
//
//  Created by Tom Nelson on 3/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import SwiftyJSON

class DataBlock {
  let data: JSON
  
  let items: [DataPoint]
  var summary: String? { return data["summary"].string }
  var icon: String? { return data["icon"].string }
  let dateFormatter: DateFormatter!
  let tempFormatter: NumberFormatter!

  required init?(from data: JSON, formatters: [Formatter]) {
    guard let dateFormatter = formatters[0] as? DateFormatter else { return nil }
    guard let tempFormatter = formatters[1] as? NumberFormatter else { return nil }
    guard DataBlock.isValid(data) else { return nil }
    
    self.dateFormatter = dateFormatter
    self.tempFormatter = tempFormatter
    self.data = data
    var items = [DataPoint]()
    
    for item in self.data["data"].arrayValue {
      if let dataPoint = DataPoint(from: item, formatters: [dateFormatter, tempFormatter]) {
        items.append(dataPoint)
      }
    }
    
    self.items = items
  }
  
  static func isValid(_ data: JSON) -> Bool {
    if data.dictionary != nil { return true }
    else { return false }
  }
}
