//
//  NavigationInteractor.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/22/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class NavigationInteractor: UIPercentDrivenInteractiveTransition {
  var navigationController: UINavigationController!
  var shouldCompleteTransition = false
  var transitionInProgress = false
  var completionSeed: CGFloat {
    return 1 - percentComplete
  }
  var width: CGFloat = 0
  
  func attachToViewController(_ viewController: UIViewController) {
    navigationController = viewController.navigationController
    setupGestureRecognizer(viewController.view)
    width = viewController.view.frame.width
  }
  
  private func setupGestureRecognizer(_ view: UIView) {
    let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
    view.addGestureRecognizer(pan)
  }
  
  func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    let viewTranslation = gestureRecognizer.translation(in: gestureRecognizer.view!.superview!)
    let velocity = gestureRecognizer.velocity(in: gestureRecognizer.view!.superview!)

    switch gestureRecognizer.state {
    case .began:
      transitionInProgress = true
      navigationController.popViewController(animated: true)

    case .changed:
      let pct = [[viewTranslation.x / width, 0].max()!, 1].min()!
      switch (Double(pct), Double(velocity.x)) {
      case (0...0.2, _): shouldCompleteTransition = false
      case (0.8...1, _): shouldCompleteTransition = true
      case(_, 0...Double.infinity): shouldCompleteTransition = true
      default: shouldCompleteTransition = false
      }
      update(pct)

    case .cancelled, .ended:
      transitionInProgress = false
      if !shouldCompleteTransition || gestureRecognizer.state == .cancelled { cancel() }
      else { finish() }
    default:()
    }
  }
  
  override func finish() {
    completionSpeed = (1 - percentComplete) * duration
    self.completionCurve = UICubicTimingParameters().animationCurve
    super.finish()
  }
  
  override func cancel() {
    completionSpeed = percentComplete * duration
    self.completionCurve = .easeIn
    super.cancel()
  }
}
