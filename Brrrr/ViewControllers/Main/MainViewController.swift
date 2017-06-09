//
//  MainViewController.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/24/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {
  fileprivate var viewModel = MainViewModel()

  @IBOutlet fileprivate weak var hourlyTopConstraint: NSLayoutConstraint!
  @IBOutlet private weak var searchBar: UISearchBar! { didSet {
    searchBar.delegate = self
  }}
  @IBOutlet fileprivate weak var headerView: HeaderCell!
  
  @IBOutlet private weak var hourlyConditions: UICollectionView! { didSet {
    hourlyConditions.dataSource = self
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
    viewModel.showError = showConnectionProblems
    viewModel.updateUI = {
      self.tableView.reloadData()
      self.hourlyConditions.reloadData()
      self.headerView.cityLabel.text = self.viewModel.city
      self.headerView.data = self.viewModel.currentData
    }
  }
  
  func showConnectionProblems(_ error: APIError) {
    let desc = error.desc()
    let alertViewController = UIAlertController(title: "Error", message: desc, preferredStyle: .alert)
    let action = UIAlertAction(title: "OK", style: .cancel)
    alertViewController.addAction(action)
    
    self.searchBar.endEditing(true)
    self.present(alertViewController, animated: true)
  }

}

extension MainViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    headerView.offset = offset
    if offset < 0 { hourlyTopConstraint.constant = -(120 + offset) }
    else { hourlyTopConstraint.constant = -120 }
  }

}

extension MainViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.dailyData.count + 1
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row < viewModel.dailyData.count {
      let  cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell")
      guard let dailyTableCell = cell as? DailyTableCell else { return  UITableViewCell() }
      
      dailyTableCell.data = viewModel.dailyData[indexPath.row]
      
      return dailyTableCell
    } else {
      let  cell = tableView.dequeueReusableCell(withIdentifier: "CurrentTableViewCell")
      guard let currentTableViewCell = cell as? CurrentCell else { return  UITableViewCell() }
      
      if let currentData = viewModel.currentData {
        currentTableViewCell.data = currentData
      }
      
      return currentTableViewCell
    }
  }
}

extension MainViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.hourlyData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCell.Identifier, for: indexPath)
    guard let hourlyCell = cell as? HourlyCell else { return  UICollectionViewCell() }
    hourlyCell.load(viewModel.hourlyData[indexPath.row])
    
    return hourlyCell
  }
}

extension MainViewController: UISearchBarDelegate {
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    viewModel.searchString = searchText
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    viewModel.searchForEvents()
    searchBar.endEditing(true)
  }
}
