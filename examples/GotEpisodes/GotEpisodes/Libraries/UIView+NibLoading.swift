//
//  UIView+NibLoading.swift
//  OnReal
//
//  Created by Fabio Butti on 04/07/17.
//  Copyright © 2017 OnReal. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
  
  // MARK: Public
  
  var nibView: UIView? {
    get {
      return self.subviews[0]
    }
  }
  
  @discardableResult
  func loadFromNib<T : UIView>() -> T {
    return loadFromNib(String(describing: type(of: self)))
  }
  
  @discardableResult
  func loadFromNib<T : UIView>(_ nibName: String) -> T {
    guard let view = Bundle(for: type(of: self) as AnyClass).loadNibNamed(nibName, owner: self, options: nil)?[0] as? T else {
      // Xib non caricato, o la sua top view è del tipo sbagliato
      return T()
    }
    addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    let topConstraint = view.topAnchor.constraint(equalTo: topAnchor)
    let rightConstraint = view.rightAnchor.constraint(equalTo: rightAnchor)
    let leftConstraint = view.leftAnchor.constraint(equalTo: leftAnchor)
    let bottomConstraint = view.bottomAnchor.constraint(equalTo: bottomAnchor)
    NSLayoutConstraint.activate([topConstraint, rightConstraint, leftConstraint, bottomConstraint])
    return view
  }
  
  
  // MARK: Private
  
  class func loadFromNib(nibName: String? = nil) -> Self {
    guard let name = nibName else {
      return loadFromNib(with: self)
    }
    return loadFromNib(name, with: self)
  }
  
  private class func loadFromNib<T : UIView>(with viewType: T.Type) -> T {
    return loadFromNib(String(describing: viewType), with: viewType)
  }
  
  private class func loadFromNib<T : UIView>(_ nibName: String, with viewType: T.Type) -> T {
    guard let view = Bundle(for: viewType).loadNibNamed(nibName, owner: self, options: nil)?[0] as? T else {
      // Xib non caricato, o la sua top view è del tipo sbagliato
      return T()
    }
    return view
  }
  
}
