//
//  ViewController.swift
//  Brrrr
//
//  Created by Tom Nelson on 2/26/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import PromiseKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
  let disposeBag = DisposeBag()

  @IBOutlet weak var displayLabel: UILabel!
  
  @IBAction func buttonAction(_ sender: UIButton) {

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
  
  func bind() {
    dataRequest()
      .observeOn(MainScheduler.instance)
      .debug("dataRequest")
      .subscribe(onNext: { weatherData in
        
        let dateString = weatherData.dateFormatter.string(from: (weatherData.minutely?.item[0].time)!)
        print(dateString)
        for item in (weatherData.minutely?.item)! {
          print ("Minutely item \(weatherData.dateFormatter.string(from: (item.time)!))")
        }
        for item in (weatherData.hourly?.item)! {
          print ("Hourly item \(weatherData.dateFormatter.string(from: (item.time)!)) \(weatherData.tempFormatter.string(from: item.apparentTemperature) ?? item.apparentTemperature.description)")
        }
        for item in (weatherData.daily?.item)! {
          print ("Daily item \(weatherData.dateFormatter.string(from: (item.time)!)) \(String(describing: weatherData.tempFormatter.string(from: item.apparentTemperatureMin)!))/\(weatherData.tempFormatter.string(from: item.apparentTemperatureMax)!)")
        }
      })
    .addDisposableTo(disposeBag)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bind()
  }
  
}
