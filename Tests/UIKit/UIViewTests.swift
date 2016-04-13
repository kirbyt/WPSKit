//
//  UIViewTests.swift
//  WPSKit
//
//  Created by Kirby Turner on 3/25/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import XCTest
@testable import WPSKit

class UIViewTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testLoadFromNib() {
    let view = LoadFromNibTestView.loadFromNib()
    XCTAssertNotNil(view)
    XCTAssertEqual(String(view.dynamicType), String(LoadFromNibTestView))
  }
  
}
