//
//  XibLoadable.swift
//  Brrrr
//
//  Created by Tom Nelson on 6/1/17.
//  Copyright © 2017 TKO Solutions. All rights reserved.
//

import UIKit

/// Use a view loaded from a nib in a storyboard / another nib or programmatically.
protocol XibLoadable {
  
  /// The interface builder tag for this view. You'll need to set this in interface
  /// builder wherever you USE the view (not where you define it.)
  var ibTag: Int { get }
  
  /// Use this to load the view programmatically
  static func get() -> UIView
  
  static func getAndConfigure(from: UIView) -> UIView
  
  func customAwakeAfter(superAwakeAfter: () -> Any?) -> Any?
  
  /// Override prepareForInterfaceBuilder and call this.
  func makeIBDesignable()
  
  /// Called after your view is instantiated. Do any setup that you can't do
  /// on outlet didSet in here.
  func setup()
}

extension XibLoadable where Self: UIView {
  static func get() -> UIView {
    let bundle = Bundle(for: self)
    let nib = UINib(nibName: String(describing: self), bundle: bundle)
    guard let view = nib.instantiate(withOwner: self, options: nil)[0]
      as? UIView else { fatalError("something is wrong") }
    
    if let view = view as? XibLoadable { view.setup() }
    return view
  }
  
  //swiftlint:disable function_body_length
  static func getAndConfigure(from: UIView) -> UIView {
    let realView = self.get()
    
    realView.frame = from.frame
    realView.autoresizingMask = from.autoresizingMask
    realView.translatesAutoresizingMaskIntoConstraints
      = from.translatesAutoresizingMaskIntoConstraints
    
    for constraint in from.constraints {
      var firstItem: AnyObject
      var secondItem: AnyObject?
      
      if constraint.firstItem as? NSObject == from { firstItem = realView }
      else { firstItem = constraint.firstItem }
      
      if let item = constraint.secondItem as? NSObject, item == from { secondItem = realView }
      else { secondItem = constraint.secondItem }
      
      let newConstraint = NSLayoutConstraint(
        item: firstItem,
        attribute: constraint.firstAttribute,
        relatedBy: constraint.relation,
        toItem: secondItem,
        attribute: constraint.secondAttribute,
        multiplier: constraint.multiplier,
        constant: constraint.constant
      )
      
      NSLayoutConstraint.activate([newConstraint])
    }
    
    return realView
  }
  
  func customAwakeAfter(superAwakeAfter: () -> Any?) -> Any? {
    if self.tag == ibTag {
      return type(of: self).getAndConfigure(from: self)
    }
    
    return superAwakeAfter()
  }
  
  func makeIBDesignable() {
    let view = type(of: self).get()
    view.frame = self.bounds
    view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    
    addSubview(view)
  }
}
