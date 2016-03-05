//
//  NSErrorsTest.swift
//  WPSKit
//
//  Created by Kirby Turner on 3/5/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import XCTest

class NSErrorsTest: XCTestCase {
  
  func testHTTPError () {
    let error = NSError.HTTPError(NSURL(string: "http://www.thecave.com/badpage.html"), statusCode: 404, message: "Page not found", data: nil)
    XCTAssertNotNil(error)
    XCTAssertEqual(error.domain, "HTTPErrorDomain")
    XCTAssertEqual(error.code, 404)
    XCTAssertEqual(error.userInfo["HTTPStatusCode"]?.integerValue, 404)
  }
  
}
