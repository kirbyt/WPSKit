//
//  UIView+WPSKit.swift
//  WPSKit
//
//  Created by Kirby Turner on 3/5/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import Foundation

extension UIView {

  /**
   Displays a frame border on the view.
   
   - parameter color: The frame border color.
   */
  public func showFrame(color: UIColor) {
    let layer: CALayer = self.layer
    layer.borderColor = color.CGColor
    layer.borderWidth = 1.0
  }

  /**
   Returns a snapshot image of the view.
   
   - returns A `UIImage` representation of the view.
   */
  public func imageSnapshot -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
    self.layer.renderInContext(UIGraphicsGetCurrentContext())
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }

}