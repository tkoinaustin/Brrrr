//
//  Alert.swift
//  Brrrr
//
//  Created by Tom Nelson on 3/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import SwiftyJSON

class Alert {
  let data: JSON
  
  var description: String { return data["description"].stringValue }
  var expires: String? { return data["expires"].string }
  var regions: String { return data["regions"].stringValue }
  var severity: String { return data["severity"].stringValue }
  var time: String { return data["time"].stringValue }
  var title: String { return data["title"].stringValue }
  var uri: String? { return data["uri"].string }
  
  required init?(from data: JSON) {
    self.data = data
  }
}
