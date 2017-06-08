//
//  MainViewModel.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/24/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit
import SwiftyJSON

class MainViewModel {
  var updateUI: (() -> Void) = { }
  var showError: ((APIError) -> Void) = { _ in }
  
  var darkSky = DarkSkyResponse.empty
  var dailyData: [DataPoint] {
    guard let data = darkSky?.daily?.items else { return [DataPoint]() }
    guard !data.isEmpty else { return [DataPoint]() }
    return data
  }
  var hourlyData: [DataPoint] {
    guard let data = darkSky?.hourly?.items else { return [DataPoint]() }
    guard !data.isEmpty else { return [DataPoint]() }
    return data
  }
  var currentData: DataPoint? {
    guard let current = darkSky?.currently else { return nil }
    return current
  }
  
  var searchString: String = "" { didSet {
    if searchString == "" {
      darkSky = DarkSkyResponse.empty
      updateUI()
    }
    }}
  
  func searchForEvents() {
    guard searchString != "" else { return }
    _ = Location.getCoordinates(searchString).then { places -> Void in
      guard let location = places[0].location else { return }
      _ = self.dataRequest(location)
    }
  }

  func dataRequest(_ location: CLLocation) -> Promise<Void> {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    return DarkSkyResponse.loadWeather(location).then { darkSkyData -> Promise<Void> in
      self.darkSky = darkSkyData
      self.updateUI()
      if darkSkyData.data == JSON.null {
        self.showError(APIError.noResults)
      }
      return Promise { fulfill, _ in
        fulfill()
      }
      }.catch { error in
        guard let apiError = error as? APIError else { return }
        self.showError(apiError)
      }.always {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  }
}
