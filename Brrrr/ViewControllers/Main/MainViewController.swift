//
//  MainViewController.swift
//  Brrrr
//
//  Created by Tom Nelson on 5/24/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit
import CoreLocation

//swiftlint:disable file_length
class MainViewController: UIViewController {
  fileprivate var viewModel = MainViewModel()
  var autoSearch = false

  @IBOutlet private weak var localWeatherButton: UIButton! { didSet { localWeatherButton.alpha = 0 } }
  @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
  @IBOutlet fileprivate weak var hourlyTopConstraint: NSLayoutConstraint!
  @IBOutlet private weak var searchBar: UISearchBar! { didSet { searchBar.delegate = self } }
  
  @IBOutlet fileprivate weak var headerView: HeaderCell!
  @IBOutlet private weak var  topLine: UIView!
  @IBOutlet private weak var bottomLine: UIView!

  @IBOutlet private weak var hourlyConditions: UICollectionView! { didSet {
    hourlyConditions.dataSource = self
    let hourlyCell = String(describing: HourlyCell.self)
    hourlyConditions.register(UINib(nibName: hourlyCell, bundle: Bundle.main),
                              forCellWithReuseIdentifier: HourlyCell.Identifier)
    
    let layout = UICollectionViewFlowLayout()
    layout.minimumInteritemSpacing = 0
    layout.minimumLineSpacing = 0
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 55, height: 90)
    hourlyConditions.collectionViewLayout = layout
  }}

  @IBOutlet fileprivate weak var tableView: UITableView! { didSet {
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 44
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.contentInset = UIEdgeInsets(top: 120, left: 0, bottom: 0, right: 0)
  }}

  @IBAction func localWeatherAction(_ sender: UIButton) {
    self.startLocalSearch()
  }
  
  func disableLocalWeatherButton() {
    self.localWeatherButton.isEnabled = false
    UIView.animate(withDuration: 0.25, animations: {
      self.localWeatherButton.alpha = 0
    })
  }
  
  func enableLocalWeatherButton() {
    self.localWeatherButton.isEnabled = true
    UIView.animate(withDuration: 0.25, animations: {
      self.localWeatherButton.alpha = 1
    })
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
    bind()
    loadInitialWeather()
  }
  
  private func loadInitialWeather() {
    let defaults = UserDefaults.standard
    if let searchCity = defaults.string(forKey: "LastSuccessfulLocation") {
      self.searchBar.text = searchCity
      self.viewModel.searchString = searchCity
      self.viewModel.getWeather()
    } else {
      self.startLocalSearch()
    }
  }
  
  private func startLocalSearch() {
    autoSearch = true
    self.disableLocalWeatherButton()
    activityIndicator.startAnimating()
    self.activityIndicator.alpha = 1
    viewModel.getLocalWeather()
  }
  
  private func bind() {
    viewModel.showError = showConnectionProblems
    viewModel.updateUI = {
      self.tableView.reloadData()
      self.hourlyConditions.reloadData()
      self.topLine.isHidden = self.viewModel.hourlyData.isEmpty
      self.bottomLine.isHidden = self.viewModel.hourlyData.isEmpty
      self.headerView.cityLabel.text = self.viewModel.city
      self.headerView.data = self.viewModel.currentData
      
      if self.autoSearch {
        self.searchBar.text = self.viewModel.city
        self.autoSearch = false 
        self.searchBar.endEditing(true)
      }
      self.activityIndicator.stopAnimating()
      self.activityIndicator.alpha = 0
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

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard let dailyViewController = segue.destination as? DailyViewController else { return }
    guard let data = sender as? DataPoint else { return }
    
    dailyViewController.data = data
    dailyViewController.city = viewModel.city
    dailyViewController.date = data.longDate
  }
}

extension MainViewController: UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y
    headerView.offset = offset
    if offset < 0 { hourlyTopConstraint.constant = -(130 + offset) }
    else { hourlyTopConstraint.constant = -130 }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView.deselectRow(at: indexPath, animated: true)
    guard indexPath.row < viewModel.dailyData.count else { return }
    
    let data = viewModel.dailyData[indexPath.row]
    self.performSegue(withIdentifier: "dailyViewSegue", sender: data)
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
        currentTableViewCell.selectionStyle = .none
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
    if searchText == "" { self.enableLocalWeatherButton() }
    else { self.disableLocalWeatherButton() }
  }
  
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.endEditing(true)
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    autoSearch = false
    viewModel.getWeather()
    searchBar.endEditing(true)
  }
}
