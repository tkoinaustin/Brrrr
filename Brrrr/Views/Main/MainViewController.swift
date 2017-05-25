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
  @IBOutlet weak var searchField: UITextField!
  @IBOutlet weak var searchResultsLabel: UILabel!
  @IBOutlet weak var longitudeLabel: UILabel!
  @IBOutlet weak var latitudeLabel: UILabel!

  let disposeBag = DisposeBag()
  private lazy var viewModel: MainViewModel = {
    return MainViewModel(self.searchField.rx.text.orEmpty)
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
      .map { $0.description }
      .drive(longitudeLabel.rx.text)
      .addDisposableTo(disposeBag)
  }
}

