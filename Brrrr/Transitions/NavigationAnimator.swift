//
//  NavigationAnimator.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/22/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

class NavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.33
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let toView = transitionContext.view(forKey: .to) else { return }
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    
    transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
    let offscreenRight = CGAffineTransform(translationX: UIScreen.main.bounds.width, y: 0)
    let slightlyLeft = CGAffineTransform(translationX: -UIScreen.main.bounds.width / 5, y: 0)
    toView.transform = slightlyLeft
    
    let dismiss = UIViewPropertyAnimator(
      duration: self.transitionDuration(using: transitionContext),
      curve: .linear,
      animations: {
        fromView.transform = offscreenRight
        toView.transform = .identity
    })

    dismiss.addCompletion { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    dismiss.startAnimation()
  }
}
