//
//  UIButton+TiknilAdditions.swift
//  OnReal
//
//  Created by Fabio Butti on 06/07/17.
//  Copyright © 2017 OnReal. All rights reserved.
//

import UIKit

extension UIView {
  
  // MARK: CORNER RADIUS
  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
    }
  }
  
  // MARK: BORDER
  @IBInspectable var borderColor: UIColor {
    get {
      guard let borderColor = layer.borderColor else {
        return .clear
      }
      return UIColor(cgColor: borderColor)
    }
    set {
      layer.borderColor = newValue.cgColor
    }
  }
  
  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }
  
  // MARK: SHADOW
  @IBInspectable var shadowColor: UIColor {
    get {
      guard let shadowColor = layer.shadowColor else {
        return .clear
      }
      return UIColor(cgColor: shadowColor)
    }
    set {
      layer.shadowColor = newValue.cgColor
    }
  }
  
  @IBInspectable var shadowOffset: CGSize {
    get {
      return layer.shadowOffset
    }
    set {
      layer.shadowOffset = newValue
    }
  }
  
  @IBInspectable var shadowOpacity: Float {
    get {
      return layer.shadowOpacity
    }
    set {
      layer.shadowOpacity = newValue
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat {
    get {
      return layer.shadowRadius
    }
    set {
      layer.shadowRadius = newValue
    }
  }
  
}
