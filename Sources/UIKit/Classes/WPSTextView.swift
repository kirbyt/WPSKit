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

/**
 `WPSTextView` is a replacement for `UITextView` providing the option of displaying placeholder text.
 */
@IBDesignable
public class WPSTextView: UITextView {
  
  /// The text displayed in the placeholder.
  @IBInspectable public var placeholderText: String? = nil {
    didSet {
      applyPlaceholderStyle()
    }
  }
  
  /// The color of the placeholder text.
  @IBInspectable public var placeholderTextColor: UIColor = UIColor.lightGrayColor() {
    didSet {
      applyPlaceholderStyle()
    }
  }
  
  override public var text: String! {
    get {
      return super.text
    }
    set {
      super.text = newValue
      setNeedsDisplay()
    }
  }
  
  /// The placeholder label used to display the placeholder.
  private let placeholderLabel: UILabel = UILabel()
  
  deinit {
    let nc = NSNotificationCenter.defaultCenter()
    nc.removeObserver(self, name: UITextViewTextDidChangeNotification, object: self)
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override public init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    setup()
  }
  
  override public func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  override public func drawRect(rect: CGRect) {
    super.drawRect(rect)
    
    var newAlpha: CGFloat = 0.0
    
    guard placeholderText?.characters.count > 0 else {
      placeholderLabel.alpha = newAlpha
      return
    }
    
    if text.characters.count == 0 {
      newAlpha = 1
    }

    guard placeholderLabel.alpha != newAlpha else {
      // Nothing changed. Let's exit.
      return
    }
    
    placeholderLabel.frame = placeholderRectForBounds(bounds)
    placeholderLabel.sizeToFit()
    placeholderLabel.alpha = newAlpha
  }
  
}

private extension WPSTextView {
  
  private func setup() {
    placeholderLabel.lineBreakMode = .ByWordWrapping
    placeholderLabel.numberOfLines = 0
    placeholderLabel.backgroundColor = UIColor.clearColor()
    placeholderLabel.alpha = 0
    
    addSubview(placeholderLabel)
    sendSubviewToBack(placeholderLabel)
    
    applyPlaceholderStyle()
    
    let nc = NSNotificationCenter.defaultCenter()
    nc.addObserver(self, selector: #selector(WPSTextView.textChanged(_:)), name: UITextViewTextDidChangeNotification, object: self)
  }
  
  private func applyPlaceholderStyle() {
    placeholderLabel.font = font
    placeholderLabel.textColor = placeholderTextColor
    placeholderLabel.text = placeholderText
  }
  
  private func placeholderRectForBounds(bounds: CGRect) -> CGRect {
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
  
  internal func textChanged(sender: AnyObject) {
    guard placeholderText?.characters.count > 0 else {
      return
    }
    
    if text.characters.count == 0 {
      placeholderLabel.alpha = 1
    } else {
      placeholderLabel.alpha = 0
    }
  }
  
}