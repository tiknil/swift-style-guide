//
//  UIView+AutoLayoutHelpers.swift
//  OnReal
//
//  Created by Fabio Butti on 07/07/17.
//  Copyright © 2017 OnReal. All rights reserved.
//

import UIKit

extension UIView {
  
  /**
   Lega alla superview con gli insets passati come parametro
   - Parameter insets: Insets (padding) rispetto alla superview
   */
  func alPinToSuperview(withInsets insets: UIEdgeInsets = UIEdgeInsets()) {
    guard let parent = superview else {
      return
    }
    translatesAutoresizingMaskIntoConstraints = false
    let constraints = [
      topAnchor.constraint(equalTo: parent.topAnchor, constant: insets.top),
      leftAnchor.constraint(equalTo: parent.leftAnchor, constant: insets.left),
      bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: -insets.bottom),
      rightAnchor.constraint(equalTo: parent.rightAnchor, constant: -insets.right),
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
  /**
   Lega alla superview mantenendo l'aspectRatio passato come parametro
   - Parameter aspectRatio: Aspect ratio che la view deve mantenere (width / height). Default = 1 (square)
   */
  func alPinToSuperviewWithAspectRatio(_ aspectRatio: Double = 1.0) {
    guard let parent = superview else {
      return
    }
    translatesAutoresizingMaskIntoConstraints = false
    let heightConstraint = heightAnchor.constraint(equalTo: parent.heightAnchor, multiplier: 1)
    heightConstraint.priority = UILayoutPriority(rawValue: 750)
    let heightConstraint2 = heightAnchor.constraint(lessThanOrEqualTo: parent.heightAnchor, multiplier: 1)
    heightConstraint2.priority = UILayoutPriority(rawValue: 1000)
    let widthConstraint = widthAnchor.constraint(equalTo: parent.widthAnchor, multiplier: 1)
    widthConstraint.priority = UILayoutPriority(rawValue: 750)
    let widthConstraint2 = widthAnchor.constraint(lessThanOrEqualTo: parent.widthAnchor, multiplier: 1)
    widthConstraint2.priority = UILayoutPriority(rawValue: 1000)
    let constraints = [
      heightConstraint,
      heightConstraint2,
      widthConstraint,
      widthConstraint2,
      widthAnchor.constraint(equalTo: heightAnchor, multiplier: CGFloat(aspectRatio)),
      centerXAnchor.constraint(equalTo: parent.centerXAnchor),
      centerYAnchor.constraint(equalTo: parent.centerYAnchor)
    ]
    NSLayoutConstraint.activate(constraints)
  }
  
}
