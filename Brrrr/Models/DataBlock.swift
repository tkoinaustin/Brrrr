//
//  DataBlock.swift
//  Brrrr
//
//  Created by Tom Nelson on 3/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import SwiftyJSON

class DataBlock {
  let data: JSON
  
  let items: [DataPoint]
  var summary: String? { return data["summary"].string }
  var icon: String? { return data["icon"].string }

  required init?(from data: JSON) {
    guard DataBlock.isValid(data) else { return nil }
    
    self.data = data
    var items = [DataPoint]()
    
    for item in self.data["data"].arrayValue {
      if let dataPoint = DataPoint(from: item) {
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
