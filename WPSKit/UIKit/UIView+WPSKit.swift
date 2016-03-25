//
// UIView+WPSKit.swift
//
// Created by Kirby Turner.
// Copyright 2016 White Peak Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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
  public func imageSnapshot() -> UIImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
    self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
  }

  /**
   Load a view from a nib.
   
   The view class name must match the nib name. Also, don't forget to 
   set the class name for your top level view in Interface Builder.
   */
  public class func loadFromNib() -> UIView {
    let nibName = String(self)
    let bundle = NSBundle(forClass: self)
    let nib = UINib(nibName: nibName, bundle: bundle)
    let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
    return view
  }
}
