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
  let disposeBag = DisposeBag()
  
  private lazy var viewModel: MainViewModel = {
    return MainViewModel(searchCriteria: self.searchBar.rx.text.orEmpty.asObservable(),
                         searchClick: self.searchBar.rx.searchButtonClicked.asObservable(),
                         cancelClick: self.searchBar.rx.cancelButtonClicked.asObservable())
  }()

  @IBOutlet private weak var searchBar: UISearchBar!
  @IBOutlet private weak var searchResultsLabel: UILabel!
  @IBOutlet private weak var longitudeLabel: UILabel!
  @IBOutlet private weak var latitudeLabel: UILabel!
  @IBOutlet private weak var minuteButton: UIButton!
  @IBOutlet private weak var currentConditionsLabel: UILabel!
  @IBOutlet private weak var symbolsLabel: UILabel!
  @IBOutlet private weak var scrollView: UIScrollView!
  
  @IBOutlet private weak var hourlyConditions: UICollectionView! { didSet {
    let hourlyCell = String(describing: HourlyCell.self)
    hourlyConditions.register(UINib(nibName: hourlyCell, bundle: Bundle.main),
                              forCellWithReuseIdentifier: HourlyCell.Identifier)
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 55, height: 75)
    hourlyConditions.collectionViewLayout = layout
    }}

  @IBOutlet private var dailyItems: [DailyCell]!
  
  @IBAction func currentAction(_ sender: UIButton) {
    viewModel.showCurrentData()
  }

  @IBAction func minutelyAction(_ sender: UIButton) {
    viewModel.showMinutelyData()
  }
  
  @IBAction func hourlyAction(_ sender: Any) {
    viewModel.showHourlyData()
  }
  
  @IBAction func dailyAction(_ sender: UIButton) {
    viewModel.showDailyData()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    scrollView.layoutIfNeeded()
  }
  
  //swiftlint:disable function_body_length
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
    
    viewModel.dailyData.asObservable()
      .debug("dailyData")
      .subscribe(onNext: { [weak self] dailyArray in
        var counter = 0
        guard dailyArray.count > 6 else { return }
        for forecast in dailyArray {
          self?.dailyItems[counter].data = forecast
          counter += 1
        }
      })
      .addDisposableTo(disposeBag)
    
    viewModel.hourlyData.asObservable()
      .bind(to: self.hourlyConditions
        .rx
        .items(cellIdentifier: HourlyCell.Identifier,
               cellType: HourlyCell.self)) { _, place, cell in
                cell.load(place)
      }
      .addDisposableTo(disposeBag)
  }
}
