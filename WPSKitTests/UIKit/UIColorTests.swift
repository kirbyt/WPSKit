//
//  UIColorTests.swift
//  WPSKit
//
//  Created by Kirby Turner on 3/5/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import XCTest

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
