//
//  NSURLTests.swift
//  WPSKit
//
//  Created by Kirby Turner on 3/23/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import XCTest

class NSURLTests: XCTestCase {

  let pathComponents = "_unittest"
  var pathsToDelete: [String] = []
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    let fm = NSFileManager.defaultManager()
    for path in pathsToDelete {
      if fm.fileExistsAtPath(path) {
        try! fm.removeItemAtPath(path)
      }
    }
    super.tearDown()
  }
  
  // MARK: - Document Directory
  
  func testDocumentDirectoryURL() {
    guard let url = NSURL.documentDirectoryURL() else {
      XCTFail()
      return
    }
    
    XCTAssertNotNil(url)
    XCTAssertTrue(url.fileURL)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(url.path!))
  }
  
  func testDocumentDirectoryWithPathComponents() {
    guard let url = try! NSURL.documentDirectoryURL(pathComponents) else {
      XCTFail()
      return
    }
    
    XCTAssertNotNil(url)
    XCTAssertTrue(url.fileURL)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(url.path!))
    pathsToDelete.append(url.path!)
  }
  
  // MARK: Cache Directory
  
  func testCacheDirectory() {
    guard let url = NSURL.cacheDirectoryURL() else {
      XCTFail()
      return
    }
    
    XCTAssertNotNil(url)
    XCTAssertTrue(url.fileURL)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(url.path!))
  }
  
  func testCacheDirectoryWithPathComponents() {
    guard let url = try! NSURL.cacheDirectoryURL(pathComponents) else {
      XCTFail()
      return
    }
    
    XCTAssertNotNil(url)
    XCTAssertTrue(url.fileURL)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(url.path!))
    pathsToDelete.append(url.path!)
  }
  
  // MARK: Temporary Directory
  
  func testTemporaryDirectory() {
    guard let url = NSURL.temporaryDirectoryURL() else {
      XCTFail()
      return
    }
    
    XCTAssertNotNil(url)
    XCTAssertTrue(url.fileURL)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(url.path!))
  }
  
  func testTemporaryDirectoryWithPathComponents() {
    guard let url = try! NSURL.temporaryDirectoryURL(pathComponents) else {
      XCTFail()
      return
    }
    
    XCTAssertNotNil(url)
    XCTAssertTrue(url.fileURL)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(url.path!))
    pathsToDelete.append(url.path!)
  }

}
