//
//  FormatService.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation

class FormatService {
  static var timezone = TimeZone(identifier: "central/Chicago")
  
  static func dayOfWeek(_ date: Double) -> String {
    let date = Date(timeIntervalSince1970: date)
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE"
    formatter.timeZone = FormatService.timezone
    return formatter.string(from: date)
  }
  
  static func hhmma (_ date: Double) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = FormatService.timezone
    formatter.dateFormat = "h:mma"
    let date = Date(timeIntervalSince1970: date)
    return formatter.string(from: date).lowercased()
  }
  
  static func ha (_ date: Double) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = FormatService.timezone
    formatter.dateFormat = "ha"
    let date = Date(timeIntervalSince1970: date)
    return formatter.string(from: date)
  }
  
  static func longDate (_ date: Double) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = FormatService.timezone
    formatter.dateFormat = "EEEE, MMMM d"
    let date = Date(timeIntervalSince1970: date)
    return formatter.string(from: date)
  }
  
  static func pct (_ number: NSNumber) -> String {
    let tempFormatter = NumberFormatter()
    tempFormatter.maximumFractionDigits = 0
    let value = NSNumber(value: number.floatValue * 100.0)
    guard let result = tempFormatter.string(from: value) else { return "" }
    return "\(result)%"
  }
  
  static func tmp (_ number: NSNumber) -> String {
    let tempFormatter = NumberFormatter()
    tempFormatter.maximumFractionDigits = 0
    guard let result = tempFormatter.string(from: number) else { return "" }
    return "\(result)"
  }
  
  static func degrees (_ number: NSNumber) -> String {
    let tempFormatter = NumberFormatter()
    tempFormatter.maximumFractionDigits = 0
    guard let result = tempFormatter.string(from: number) else { return "" }
    return "\(result)\u{00B0}"
  }
  
  static func degreesF (_ number: NSNumber) -> String {
    let tempFormatter = NumberFormatter()
    tempFormatter.maximumFractionDigits = 0
    guard let result = tempFormatter.string(from: number) else { return "" }
    return "\(result)\u{00B0}F"
  }
}
