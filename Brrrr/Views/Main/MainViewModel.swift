//
//  MainViewModel.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/24/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift
import RxCocoa

class MainViewModel {
  let disposeBag = DisposeBag()
  var darkSky = Variable<DarkSkyResponse>(DarkSkyResponse.empty!)
  var hourlyData = Variable<[DataPoint]>([])
  var dailyData = Variable<[DataPoint]>([])
  
  let dailyForecast: Driver<[DataPoint]>
  let locationDescription: Driver<String>
  let locationLatitude: Driver<String>
  let locationLongitude: Driver<String>
  let currentConditions: Driver<String>
  let endEditing: Observable<Void>

  //swiftlint:disable function_body_length
  //swiftlint:disable line_length
  init(searchCriteria: Observable<String>,
       searchClick: Observable<Void>,
       cancelClick: Observable<Void>
    ) {
    
    let coordinates = searchClick
    .withLatestFrom(searchCriteria)
      .flatMap { searchString in
        return Location.getCoordinates(searchString)
    }
    .share()
    
    endEditing = Observable.of(searchClick, cancelClick).merge()
    
    locationDescription = coordinates
      .map { place in
        if place.isEmpty { return "" }
        return "\(place[0].name ?? ""), \(place[0].administrativeArea ?? ""), \(place[0].isoCountryCode ?? ""), \(place[0].postalCode ?? "") \n "
      }
      .asDriver(onErrorJustReturn: "No match found")
    
    locationLatitude = coordinates
      .map { place in
        if place.isEmpty { return "" }
        return place[0].location!.coordinate.latitude.description
    }
    .asDriver(onErrorJustReturn: "")
    
    locationLongitude = coordinates
      .map { place in
        if place.isEmpty { return "" }
        return place[0].location!.coordinate.longitude.description
      }
      .asDriver(onErrorJustReturn: "")
    
    let weather = coordinates
      .filter { places in !places.isEmpty }
      .filter { places in places[0].location != nil }
      .map { places -> CLLocation in return places[0].location! }
      .flatMap { location in return MainViewModel.dataRequest(location) }
      .share()
    
    currentConditions = weather
      .map { data in
        guard let item = data.currently else { return "" }
        let clouds = item.cloudCover == nil ? "" : "\nCloud Cover: \(item.cloudCover!)%"
        let humid = item.humidity == nil ? "" : "\nHumidity: \(item.humidity!)%"
        
        return "\(item.summary)\nTemp: \(item.temperature)\u{00B0}F\nFeels like: \(item.apparentTemperature)\u{00B0}F\(clouds)\(humid)"
    }
    .asDriver(onErrorJustReturn: "")
    
    dailyForecast = weather
      .map { data in
        return (data.daily?.items)!
      }
      .asDriver(onErrorJustReturn: [])

    weather
      .subscribe(onNext: { data in
        self.darkSky.value = data
        if let hourly = data.hourly?.items {
          self.hourlyData.value = hourly
        }
        if let daily = data.daily?.items {
          self.dailyData.value = daily
        }
      })
      .addDisposableTo(disposeBag)
}
  
  // this turns the promise into an observable
  static func dataRequest(_ location: CLLocation) -> Observable<DarkSkyResponse> {
    return Observable.create { observer in
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
      DarkSkyResponse.loadWeather(location).then { darkSkyData -> Void in
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        observer.onNext(darkSkyData)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}
