//
//  IntroViewController.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/15/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
  var firstTimeThrough = true

  @IBOutlet private weak var brrrrLabel: UILabel!
  @IBOutlet private weak var welcomeView: UIStackView!
  @IBOutlet private weak var continueButton: UIButton!
  @IBAction func continueAction(_ sender: UIButton) {
    self.startNextSegue()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let height = view.frame.height
    let welcomeTransform = CGAffineTransform.identity.translatedBy(x: 0, y: height)
    welcomeView.transform = welcomeTransform
    continueButton.tintColor = UIColor.black
    if needFTUE() { self.welcomeView.alpha = 0 }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    let height = view.frame.height
    let transformLogo = CGAffineTransform.identity.translatedBy(x: 0, y: -height)
    UIView.animate(withDuration: 0.8, delay: 0.1, options: UIViewAnimationOptions(), animations: {
      self.brrrrLabel.transform = transformLogo
      self.welcomeView.transform = CGAffineTransform.identity
    }, completion: { _ in
      if self.needFTUE() { self.startNextSegue() }
    })
  }
  
  private func startNextSegue() {
    guard firstTimeThrough else { return }
    firstTimeThrough = false
    if needFTUE() {
      performSegue(withIdentifier: "FTUESegue", sender: self)
    } else {
      performSegue(withIdentifier: "mainSegue", sender: nil)
    }
  }
  
  private func needFTUE() -> Bool {
    guard UserDefaults.standard.value(forKey: "FTUE") != nil else { return true }
    return false
  }
}
