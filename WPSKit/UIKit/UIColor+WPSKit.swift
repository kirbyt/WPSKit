//
// UIColor+WPSKit.swift
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
 A set of extensions for `UIColor`.
 */
extension UIColor {

  // -------------------------------------------------------------------
  // MARK: - Properties
  // -------------------------------------------------------------------
  
  /**
   A hex string representation of the color (e.g. FFFFFF for white).
  */
  public var hexString: String {
    get {
      var red: CGFloat = 0.0
      var green: CGFloat = 0.0
      var blue: CGFloat = 0.0
      
      let numberOfComponents: size_t = CGColorGetNumberOfComponents(self.CGColor);
      let components = CGColorGetComponents(self.CGColor);
      
      if (numberOfComponents == 2) {
        // Assume white color space.
        let white: CGFloat = components[0]
        red = white
        green = white
        blue = white
      } else if (numberOfComponents == 4) {
        // RBG plus Alpha.
        red = components[0]
        green = components[1]
        blue = components[2]
      }
      
      // Fix range if needed. Color should be between 0.0 and 1.0.
      red = min(1.0, max(0.0, red))
      green = min(1.0, max(0.0, green))
      blue = min(1.0, max(0.0, blue))
      
      return String(format: "%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
  }
  
  // -------------------------------------------------------------------
  // MARK: - Init Methods
  // -------------------------------------------------------------------

  /**
   Create a new instance of `UIColor` with the provided hex and alpha values.
   
   Usage: `let red = UIColor(hex: 0xff0000)`
  
   - parameter hex:     A color value represented as hex.
   
   - returns An initialized color object.
   */
  public convenience init(hex: Int) {
    self.init(hex: hex, alpha: 1.0)
  }
  
  /**
   Create a new instance of `UIColor` with the provided hex and alpha values.
   
   Usage: `let red = UIColor(hex: 0xff0000, alpha: 0.0)`
   
   - parameter hex:     A color value represented as hex.
   - parameter alpha:   The opacity value of the color object, specified as a value from 0.0 to 1.0.
   
   - returns An initialized color object.
   */
  public convenience init(hex: Int, alpha: Float) {
    // The following code is from Graham Lee.
    // https://gist.github.com/iamleeg/7605110
    
    let redComponent = (hex & 0xff0000) >> 16
    let greenComponent = (hex & 0x00ff00) >> 8
    let blueComponent = (hex & 0xff)
    let red = CGFloat(redComponent) / 255.0
    let green = CGFloat(greenComponent) / 255.0
    let blue = CGFloat(blueComponent) / 255.0
    
    self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
  }
  
  /**
   Create a new instance of `UIColor` with the provided hex string.
   
   Usage: `let red = UIColor(hexString: "#FFFFFF)`
   
   - parameter hexString:   A color value represented as hex string. The # prefix is optional.
   
   - returns An initialized color object.
   */
  public convenience init(hexString: String) {
    self.init(hexString: hexString, alpha: 1.0)
  }
  
  /**
   Create a new instance of `UIColor` with the provided hex string and alpha value.
   
   Usage: `let red = UIColor(hexString: "#FFFFFF, alpha: 0.9)`
   
   - parameter hexString:   A color value represented as hex string. The # prefix is optional.
   - parameter alpha:       The opacity value of the color object, specified as a value from 0.0 to 1.0.
   
   - returns An initialized color object.
   */
  public convenience init(hexString: String, alpha: Float) {

    // The following code is a modified version from NachoMan.
    // https://github.com/NachoMan/phonegap/blob/bedf10f873a79c66aea5d89e380479273269eaf7/iphone/Classes/NSString+HexColor.m
    
    var hexColor = hexString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString

    if hexColor.hasPrefix("#") {
      hexColor = hexColor.substringFromIndex(hexColor.startIndex.advancedBy(1))
    }
    
    guard hexColor.characters.count == 6 else {
      self.init(white: 0, alpha: CGFloat(alpha))
      return
    }
    
    let redString = hexColor.substringWithRange(Range<String.Index>(start: hexColor.startIndex, end: hexColor.startIndex.advancedBy(2)))
    let greenString = hexColor.substringWithRange(Range<String.Index>(start: hexColor.startIndex.advancedBy(2), end: hexColor.startIndex.advancedBy(4)))
    let blueString = hexColor.substringWithRange(Range<String.Index>(start: hexColor.startIndex.advancedBy(4), end: hexColor.startIndex.advancedBy(6)))

    // Scan values
    var r: UInt32 = 0
    var g: UInt32 = 0
    var b: UInt32 = 0
    NSScanner(string: redString).scanHexInt(&r)
    NSScanner(string: greenString).scanHexInt(&g)
    NSScanner(string: blueString).scanHexInt(&b)
    
    let red = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue = CGFloat(b) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
  }
  
  // MARK: - Colors
  
  /**
   Create a new instance of `UIColor` representing a random color.
  
   - returns An initialized color object.
   */
  public class func randomColor() -> UIColor {
    // Modified version.
    // Original version copyright Kyle Fox.
    // Original version available at: https://gist.github.com/kylefox/1689973
  
    let hue: CGFloat = ( CGFloat(arc4random_uniform(256)) / 256.0 )  //  0.0 to 1.0
    let saturation: CGFloat = ( CGFloat(arc4random_uniform(128)) / 256.0 ) + 0.5  //  0.5 to 1.0, away from white
    let brightness: CGFloat = ( CGFloat(arc4random_uniform(128)) / 256.0 ) + 0.5  //  0.5 to 1.0, away from black
    return UIColor(hue:hue, saturation:saturation, brightness:brightness, alpha:1)
  }

  /**
   Create a new instance of `UIColor` representing the iOS default blue color.
   
   - returns An initialized color object.
   */
  public class func iOSDefaultBlue() -> UIColor {
    return UIColor(hex: 0x007aff)
  }

  /**
   Create a new instance of `UIColor` representing the Facebook blue color.
   
   - returns An initialized color object.
   */
  public class func facebookBlue() -> UIColor {
    return UIColor(hex: 0x3B5999)
  }

  /**
   Create a new instance of `UIColor` representing the Twitter blue color.
   
   - returns An initialized color object.
   */
  public class func twitterBlue() -> UIColor {
    return UIColor(hex: 0x55acee)
  }

}
