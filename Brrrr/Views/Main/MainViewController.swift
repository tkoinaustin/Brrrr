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
  
  @IBOutlet private weak var hourlyTopConstraint: NSLayoutConstraint!
  fileprivate lazy var viewModel: MainViewModel = {
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
  
  @IBOutlet private weak var currentView: HeaderCell!
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

  @IBOutlet fileprivate weak var tableView: UITableView! { didSet {
    tableView.dataSource = self
    tableView.estimatedRowHeight = 100
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
  }}
  
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
  var fds: UITableViewHeaderFooterView!

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    print("offset y is \(offset)")
    if offset < 0 {
      hourlyTopConstraint.constant = -(120 + offset)
      currentView.tempLabel.alpha = max((-75.0 - offset)/75.0, 0)
    } else {
      hourlyTopConstraint.constant = -120
      currentView.tempLabel.alpha = 0.0
    }
  }
  
  //swiftlint:disable function_body_length
  func bind() {
    
    viewModel.endEditing.asObservable()
      .subscribe(onNext: { [weak self] in
        self?.searchBar.endEditing(true)
      })
    .addDisposableTo(disposeBag)
    
    viewModel.dailyData.asObservable()
      .debug("dailyData")
      .subscribe(onNext: { [weak self] _ in
        self?.tableView.reloadData()
        self?.currentView.data = self?.viewModel.darkSky.value.currently
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

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.dailyData.value.count
  }
  
  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let  cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell")     
    guard let dailyTableCell = cell as? DailyTableCell else { return  UITableViewCell() }

    dailyTableCell.data = viewModel.dailyData.value[indexPath.row]
    
    return dailyTableCell
  }

}
