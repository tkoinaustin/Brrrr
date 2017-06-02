//
//  DateService.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation

class DateService {  
  static func dayOfWeek(_ date: Double) -> String {
    let date = Date(timeIntervalSince1970: date)
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    return formatter.string(from: date)
  }
  
  static func hhmma (_ date: Double) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mma"
    let date = Date(timeIntervalSince1970: date)
    return formatter.string(from: date).lowercased()
  }
}
