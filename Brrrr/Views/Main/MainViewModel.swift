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
  
  let locationDescription: Driver<String>
  let locationLatitude: Driver<String>
  let locationLongitude: Driver<String>
  let currentConditions: Driver<String>

  //swiftlint:disable function_body_length
  //swiftlint:disable line_length
  init(searchCriteria: ControlProperty<String>,
       minuteAction: ControlEvent<Void>
    ) {
    let coordinates = searchCriteria.asObservable()
      .debounce(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { !$0.characters.isEmpty }
      .debug("place")
      .flatMap { searchString in
        return Location.getCoordinates(searchString)
          .catchErrorJustReturn([CLPlacemark]())
      }
      .share()
    
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
        
        return "\(item.summary!)\nTemp: \(item.temperature!)\u{00B0}F\nFeels like: \(item.apparentTemperature!)\u{00B0}F\(clouds)\(humid)"
    }
    .asDriver(onErrorJustReturn: "")

    minuteAction.asObservable()
      .subscribe(onNext: { [weak self] _ in
        self?.showMinutelyData()
      })
    .addDisposableTo(disposeBag)
    
    weather
      .subscribe(onNext: { data in
        self.darkSky.value = data
      })
      .addDisposableTo(disposeBag)
}
  
  // this turns the promise into an observable
  static func dataRequest(_ location: CLLocation) -> Observable<DarkSkyResponse> {
    return Observable.create { observer in
      DarkSkyResponse.loadWeather(location).then { darkSkyData -> Void in
        observer.onNext(darkSkyData)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  private func showMinutelyData() {
    guard let items = darkSky.value.minutely?.item else { return }
    for point in items {
      let precipError = point.precipIntensityError == nil ? "" : "+/-\(point.precipIntensityError!)"
      let precipType = point.precipType == nil ? "" : ", Type: \(point.precipType!)"
      print("\(String(describing: point.prettyDate!)), Prob: \(String(describing: point.precipProbability))\(precipError), Intnsty: \(String(describing: point.precipIntensity))\(precipType)")
    }
  }
  
  func showCurrentData() {
    guard let item = darkSky.value.currently else { return }
    let clouds = item.cloudCover == nil ? "" : "\nCloud Cover: \(item.cloudCover!)%"
    let humid = item.humidity == nil ? "" : "\nHumidity: \(item.humidity!)%"
    
    print("\(item.summary!)\nTemp: \(item.temperature!)\u{00B0}F\nFeels like: \(item.apparentTemperature!)\u{00B0}F\(clouds)\(humid)")
  }
}
