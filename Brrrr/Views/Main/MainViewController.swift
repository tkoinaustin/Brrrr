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
  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var searchResultsLabel: UILabel!
  @IBOutlet private weak var longitudeLabel: UILabel!
  @IBOutlet private weak var latitudeLabel: UILabel!
  @IBOutlet private weak var minuteButton: UIButton!
  @IBOutlet private weak var currentConditionsLabel: UILabel!
  @IBOutlet weak var hourlyConditions: UICollectionView!
  
  @IBAction func currentAction(_ sender: UIButton) {
    viewModel.showCurrentData()
  }

  @IBAction func minutelyAction(_ sender: UIButton) {
    viewModel.showMinutelyData()
  }
  
  @IBAction func hourlyAction(_ sender: Any) {
    viewModel.showHourlyData()
  }
  
  let disposeBag = DisposeBag()
  private lazy var viewModel: MainViewModel = {
    return MainViewModel(searchCriteria: self.searchBar.rx.text.orEmpty.asObservable(),
                         searchClick: self.searchBar.rx.searchButtonClicked.asObservable(),
                         cancelClick: self.searchBar.rx.cancelButtonClicked.asObservable())

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
    
    viewModel.endEditing.asObservable()
      .subscribe(onNext: { [weak self] in
        self?.searchBar.endEditing(true)
      })
    .addDisposableTo(disposeBag)
  }
}
