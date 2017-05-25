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
  let darkSky = Variable<DarkSkyResponse>(DarkSkyResponse.empty!)
  
  let locationDescription: Driver<String>

  init(_ searchCriteria: ControlProperty<String>) {
    let place = searchCriteria.asObservable()
      .debounce(0.5, scheduler: MainScheduler.instance)
      .distinctUntilChanged()
      .filter { $0.characters.count > 0 }
      .debug("place")
      .flatMap { searchString in
        return Location.getCoordinates(searchString)
          .catchErrorJustReturn([CLPlacemark]())
      }
      .share()
    
    locationDescription = place
      .map { place in
        if place.isEmpty { return "" }
        return "\(place[0].name ?? ""), \(place[0].administrativeArea ?? ""), \(place[0].isoCountryCode ?? ""), \(place[0].postalCode ?? "") \n "
      }
      .asDriver(onErrorJustReturn: "No match found")    
  }
  
  func dataRequest() -> Observable<DarkSkyResponse> {
    return Observable.create { observer in
      DarkSkyResponse.loadPromise().then { darkSkyData -> Void in
        observer.onNext(darkSkyData)
        observer.onCompleted()
      }
      return Disposables.create()
    }
  }
}
