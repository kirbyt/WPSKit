//
//  StringTests.swift
//  WPSKit
//
//  Created by Kirby Turner on 3/5/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import XCTest

class StringTests: XCTestCase {
  
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
  
  func testDocumentDirectory() {
    let dir = String.documentDirectory()
    XCTAssertNotNil(dir)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(dir!))
  }
  
  func testDocumentDirectoryWithPathComponents() {
    let dir = try! String.documentDirectory(pathComponents)
    XCTAssertNotNil(dir)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(dir!))
    pathsToDelete.append(dir!)
  }

  // MARK: Cache Directory
  
  func testCacheDirectory() {
    let dir = String.cacheDirectory()
    XCTAssertNotNil(dir)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(dir!))
  }
  
  func testCacheDirectoryWithPathComponents() {
    let dir = try! String.cacheDirectory(pathComponents)
    XCTAssertNotNil(dir)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(dir!))
    pathsToDelete.append(dir!)
  }

  // MARK: Temporary Directory
  
  func testTemporaryDirectory() {
    let dir = String.temporaryDirectory()
    XCTAssertNotNil(dir)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(dir!))
  }
  
  func testTemporaryDirectoryWithPathComponents() {
    let dir = try! String.temporaryDirectory(pathComponents)
    XCTAssertNotNil(dir)
    XCTAssertTrue(NSFileManager.defaultManager().fileExistsAtPath(dir!))
    pathsToDelete.append(dir!)
  }

}
