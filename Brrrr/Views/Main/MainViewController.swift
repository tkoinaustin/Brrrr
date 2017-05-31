//
//  MainViewController.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/24/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import CoreLocation

class MainViewController: UIViewController {
  @IBOutlet private weak var searchField: UITextField!
  @IBOutlet private weak var searchResultsLabel: UILabel!
  @IBOutlet private weak var longitudeLabel: UILabel!
  @IBOutlet private weak var latitudeLabel: UILabel!
  @IBOutlet private weak var minuteButton: UIButton!
  @IBOutlet private weak var currentConditionsLabel: UILabel!
  
  @IBAction func currentAction(_ sender: UIButton) {
    viewModel.showCurrentData()
  }

  let disposeBag = DisposeBag()
  private lazy var viewModel: MainViewModel = {
    return MainViewModel(searchCriteria: self.searchField.rx.text.orEmpty,
                         minuteAction: self.minuteButton.rx.tap)
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  func bind() {
    viewModel.locationDescription
      .drive(searchResultsLabel.rx.text)
      .addDisposableTo(disposeBag)
    
    viewModel.locationLatitude
      .drive(latitudeLabel.rx.text)
      .addDisposableTo(disposeBag)
    
    viewModel.locationLongitude
      .drive(longitudeLabel.rx.text)
      .addDisposableTo(disposeBag)
    
    viewModel.currentConditions
      .drive(currentConditionsLabel.rx.text)
      .addDisposableTo(disposeBag)
  }
}
