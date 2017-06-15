//
//  MainViewModel.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/24/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import CoreLocation
//import PromiseKit
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
  var place: CLPlacemark?
  
  var city: String {
    let countryCode = place?.addressDictionary?["CountryCode"] as? String
    let state = place?.addressDictionary?["State"] as? String ?? ""
    let city = place?.addressDictionary?["City"] as? String ?? ""
    let suffix = countryCode == "US" ? state : countryCode ?? ""
    return"\(city), \(suffix)"
  }
  
  var searchString: String = "" { didSet {
    if searchString == "" {
      darkSky = DarkSkyResponse.empty
      updateUI()
    }
    }}
  
  func searchForEvents() {
    guard searchString != "" else { return }
    Location.getCoordinates(searchString) { (placemarkBuilder: PlacemarkBuilder) in
      do {
        let places = try placemarkBuilder()
        self.place = places[0]
        guard let location = places[0].location else { return }
        _ = self.dataRequest(location)
      } catch {
        guard let apiError = error as? APIError else { return }
        self.showError(apiError)
      }
    }
  }
  
  func dataRequest(_ location: CLLocation) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    
    DarkSkyResponse.loadWeather(location) { darkSkyData, error  in
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      
      if let data = darkSkyData { self.darkSky = data }
      else { self.darkSky = DarkSkyResponse.empty }
      
      DispatchQueue.main.async {
        self.updateUI()
        self.saveLocation(self.city)
      }
      
      if error != nil {
        DispatchQueue.main.async {
          self.showError(error!)
        }
      }
    }
  }
  
  private func saveLocation(_ location: String) {
    let defaults = UserDefaults.standard
    print("Saving city location \(location)")
    defaults.set(location, forKey: "LastSuccessfulLocation")
  }
}
