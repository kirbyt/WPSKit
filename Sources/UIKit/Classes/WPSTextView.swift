//
//  WPSTextView.swift
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

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/**
 `WPSTextView` is a replacement for `UITextView` providing the option of displaying placeholder text.
 */
@IBDesignable
open class WPSTextView: UITextView {
  
  /// The text displayed in the placeholder.
  @IBInspectable open var placeholderText: String? = nil {
    didSet {
      applyPlaceholderStyle()
    }
  }
  
  /// The color of the placeholder text.
  @IBInspectable open var placeholderTextColor: UIColor = UIColor.lightGray {
    didSet {
      applyPlaceholderStyle()
    }
  }
  
  /// The placeholder label used to display the placeholder.
  fileprivate let placeholderLabel: UILabel = UILabel()
  
  override open var text: String! {
    didSet {
      setNeedsDisplay()
    }
  }

  override open var attributedText: NSAttributedString! {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override open var contentInset: UIEdgeInsets {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override open var font: UIFont? {
    didSet {
      setNeedsDisplay()
    }
  }
  
  deinit {
    let nc = NotificationCenter.default
    nc.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: self)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override public init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setup()
  }
  
  override open func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override open func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard placeholderText?.characters.count > 0
      && text.characters.count == 0 else {
        placeholderLabel.alpha = 0
        return
    }
    
    placeholderLabel.frame = placeholderRectForBounds(bounds)
    placeholderLabel.sizeToFit()
    placeholderLabel.alpha = 1
  }
  
}

private extension WPSTextView {
  
  func setup() {
    placeholderLabel.lineBreakMode = .byWordWrapping
    placeholderLabel.numberOfLines = 0
    placeholderLabel.backgroundColor = UIColor.clear
    placeholderLabel.alpha = 0
    
    addSubview(placeholderLabel)
    sendSubview(toBack: placeholderLabel)
    
    applyPlaceholderStyle()
    
    let nc = NotificationCenter.default
    nc.addObserver(self, selector: #selector(WPSTextView.textChanged(_:)), name: NSNotification.Name.UITextViewTextDidChange, object: self)
  }
  
  func applyPlaceholderStyle() {
    placeholderLabel.font = font
    placeholderLabel.textColor = placeholderTextColor
    placeholderLabel.text = placeholderText
  }
  
  func placeholderRectForBounds(_ bounds: CGRect) -> CGRect {
    //
    // Created by Sam Soffes on 8/18/10.
    // From: https://github.com/soffes/SAMTextView
    //

    var rect = UIEdgeInsetsInsetRect(bounds, self.textContainerInset)
    let padding = self.textContainer.lineFragmentPadding
    rect.origin.x += padding
    rect.size.width -= padding * 2
    
    return rect
  }
  
}

internal extension WPSTextView {
  
  internal func textChanged(_ sender: AnyObject) {
    setNeedsDisplay()
  }
  
}
