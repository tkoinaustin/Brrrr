//
//  ViewController.swift
//  Brrrr
//
//  Created by Tom Nelson on 2/26/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import PromiseKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    //    let data = DarkSkyResponse.load()
    DarkSkyResponse.loadPromise().then { darkSkyData in
//      print("\(darkSkyData)")
      print("\(darkSkyData.minutely?.summary)")
    }
    //      if let currentTemp = darkSkyData["currently"]["apparentTemperature"].string {
    //        print("temperature is \(currentTemp)")
  }
  
}
