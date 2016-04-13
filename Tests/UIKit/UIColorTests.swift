//
// UIColorTests.swift
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

import XCTest
@testable import WPSKit

class UIColorTests: XCTestCase {

  func testColorWithHex() {
    var color = UIColor(hex: 0x007aff)
    XCTAssertEqual(color.hexString, "007AFF")
    
    color = UIColor(hex: 0xe3e3e3)
    XCTAssertEqual(color.hexString, "E3E3E3")
    
    color = UIColor(hex: 0xAAAAAA)
    XCTAssertEqual(color.hexString, "AAAAAA")
  }
  
  func testColorWithHexString() {
    var color = UIColor(hexString: "007AFF")
    XCTAssertEqual(color.hexString, "007AFF")

    color = UIColor(hexString: "e3e3e3")
    XCTAssertEqual(color.hexString, "E3E3E3")

    color = UIColor(hexString: "#e3e3e3")
    XCTAssertEqual(color.hexString, "E3E3E3")
    
    color = UIColor.whiteColor()
    XCTAssertEqual(color.hexString, "FFFFFF")

    color = UIColor.yellowColor()
    XCTAssertEqual(color.hexString, "FFFF00")

    color = UIColor.redColor()
    XCTAssertEqual(color.hexString, "FF0000")
    
    color = UIColor.lightGrayColor()
    XCTAssertEqual(color.hexString, "AAAAAA")

    color = UIColor.blackColor()
    XCTAssertEqual(color.hexString, "000000")
  }
  
  func testColors() {
    XCTAssertEqual(UIColor.iOSDefaultBlue().hexString, "007AFF")
    XCTAssertEqual(UIColor.facebookBlue().hexString, "3B5999")
    XCTAssertEqual(UIColor.twitterBlue().hexString, "55ACEE")

    XCTAssertNotNil(UIColor.randomColor())
  }
}
