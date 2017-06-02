//
//  Icons.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation

class Icon {
  //swiftlint:disable function_body_length
  static func meaning(_ icon: String) -> String {
    switch icon {
    case "clear-day":
      return "\u{f11b}"
    case "clear-night":
      return "\u{f110}"
    case "rain":
      return "\u{f113}"
    case "snow":
      return "\u{f119}"
    case "sleet", "03n":
      return "\u{f116}"
    case "wind":
      return "\u{f10e}"
    case "fog":
      return "\u{f10e}"
    case "cloudy":
      return "\u{f111}"
    case "partly-cloudy-day":
      return "\u{f112}"
    case "partly-cloudy-night":
      return "\u{f104}"
    default:
      return "\u{f111}"
    }
  }
}
