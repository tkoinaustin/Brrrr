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
  
  @IBOutlet fileprivate weak var hourlyTopConstraint: NSLayoutConstraint!
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
  @IBOutlet fileprivate weak var headerView: HeaderCell!
  
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
    tableView.delegate = self
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.contentInset = UIEdgeInsets(top: 150, left: 0, bottom: 0, right: 0)
  }}

  override func viewDidLoad() {
    super.viewDidLoad()
    bind()
  }
  
  //swiftlint:disable function_body_length
  func bind() {
    
    viewModel.endEditing.asObservable()
      .subscribe(onNext: { [weak self] in
        self?.searchBar.endEditing(true)
      })
    .addDisposableTo(disposeBag)
    
    viewModel.dailyData.asObservable()
      .skip(1)
      .subscribe(onNext: { [weak self] _ in
        self?.tableView.reloadData()
      })
      .addDisposableTo(disposeBag)
    
    viewModel.darkSky.asObservable()
      .skip(1)
      .subscribe(onNext: { [weak self] darksky in
        self?.headerView.cityLabel.text = self?.searchBar.text
        self?.headerView.data = darksky.currently

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
extension MainViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    headerView.offset = offset
    print("offset is \(offset), header height is \(headerView.frame.size.height)")
    if offset < 0 { hourlyTopConstraint.constant = -(120 + offset) }
    else { hourlyTopConstraint.constant = -120 }
  }

}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.dailyData.value.count + 1
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row < viewModel.dailyData.value.count {
      let  cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell")
      guard let dailyTableCell = cell as? DailyTableCell else { return  UITableViewCell() }
      
      dailyTableCell.data = viewModel.dailyData.value[indexPath.row]
      
      return dailyTableCell
    } else {
      let  cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTableViewCell")
      guard let currentTableViewCell = cell as? CurrentCell else { return  UITableViewCell() }
      
      if let currentData = viewModel.darkSky.value.currently, !currentData.data.isEmpty {
        currentTableViewCell.data = currentData
      }
      
      return currentTableViewCell
    }
  }
}
