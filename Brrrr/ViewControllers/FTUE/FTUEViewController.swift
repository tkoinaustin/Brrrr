//
//  FTUEViewController.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/16/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class FTUEViewController: UIViewController {
  
  var offsetStart: CGFloat!
  var offsetFinish: CGFloat!

  @IBOutlet fileprivate weak var panelsView: UIScrollView! { didSet {
    panelsView.delegate = self
  }}

  @IBOutlet fileprivate weak var pageControl: UIPageControl!
  
  @IBOutlet private var panelOne: UIView!
  @IBOutlet private var panelTwo: UIView!
  @IBOutlet private var panelThree: UIView!
  @IBOutlet private var panelFour: UIView!
  @IBOutlet private var panelFive: UIView!
  
  override func viewDidLoad() {
    addPanels()
    
    super.viewDidLoad()
  }
  
  private func addPanels() {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    print(UIScreen.main.bounds)
    offsetStart = 3 * width
    offsetFinish = 3.5 * width + 1

    panelsView.frame = CGRect(x: 0, y: -20, width: width, height: height)
    panelOne.frame = CGRect(x: 0, y: 0, width: width, height: height)
    panelTwo.frame = CGRect(x: width, y: 0, width: width, height: height)
    panelThree.frame = CGRect(x: width * 2, y: 0, width: width, height: height)
    panelFour.frame = CGRect(x: width * 3, y: 0, width: width, height: height)
    panelFive.frame = CGRect(x: width * 4, y: 0, width: width, height: height)
    
    panelsView.addSubview(panelOne)
    panelsView.addSubview(panelTwo)
    panelsView.addSubview(panelThree)
    panelsView.addSubview(panelFour)
    panelsView.addSubview(panelFive)
    
    panelsView.contentSize = CGSize(width: width * CGFloat(pageControl.numberOfPages), height: height)
  }
  
  fileprivate func isLastPage(_ currentPage: Int) -> Bool {
    return currentPage == (pageControl.numberOfPages - 1)
  }
}

extension FTUEViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let width = UIScreen.main.bounds.width
    let page = floor(panelsView.contentOffset.x / width)
    pageControl.currentPage = Int(page)
    
    guard isLastPage(pageControl.currentPage) else { return }
    
    guard let navController = UIStoryboard(name: "MainView", bundle: nil)
      .instantiateInitialViewController() else { return }
    UIApplication.shared.keyWindow?.rootViewController = navController
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    var alpha: CGFloat
    
    switch panelsView.contentOffset.x {
    case offsetFinish...CGFloat.greatestFiniteMagnitude: pageControl.alpha = 0
    case offsetStart..<offsetFinish:
      alpha = 1 - (panelsView.contentOffset.x - offsetStart) / (offsetStart / 5)
      pageControl.alpha = alpha
    default: ()
    }
  }
}
