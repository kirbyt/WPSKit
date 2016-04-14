//
//  ArrayDataSourceTests.swift
//  WPSKit
//
//  Created by Kirby Turner on 4/13/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import XCTest
@testable import WPSKit

class ArrayDataSourceTests: XCTestCase {

  override func setUp() {
    super.setUp()
  }
  
  func testDataSource_objectAtIndexPath() {
    let dataSource = ArrayDataSource()
    dataSource.array = [["One", "Two"], ["Three", "Four"]]
    XCTAssertEqual((dataSource.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as? String), "One", "Should be 'One'.")
    XCTAssertEqual((dataSource.objectAtIndexPath(NSIndexPath(forRow: 1, inSection: 0)) as? String), "Two", "Should be 'Two'.")
    XCTAssertEqual((dataSource.objectAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as? String), "Three", "Should be 'Three'.")
    
    XCTAssertNil((dataSource.objectAtIndexPath(NSIndexPath(forRow: 3, inSection: 5)) as? String), "Should be nil.")
  }
  
  func testTableView_numberOfSections() {
    let dataSource = ArrayDataSource()
    dataSource.array = [["One", "Two"], ["Three", "Four"]]
    
    let tableView = UITableView()
    tableView.dataSource = dataSource
    
    XCTAssertEqual(tableView.numberOfSections, 2, "Should have 2 sections.")
  }

  func testTableView_numberOfRowsInSections() {
    let dataSource = ArrayDataSource()
    dataSource.array = [["One", "Two", "Three", "Four"], ["Five"]]
    
    let tableView = UITableView()
    tableView.dataSource = dataSource
    
    XCTAssertEqual(tableView.numberOfRowsInSection(0), 4, "Should have 4 rows in section 0.")
    XCTAssertEqual(tableView.numberOfRowsInSection(1), 1, "Should have 1 row in section 1.")
  }
  
  func testTableView_defaultCellIdentifier() {
    let dataSource = ArrayDataSource(defaultCellIdentifier: "id")
    dataSource.array = [["One"]]
    
    let tableView = UITableView()
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")
    tableView.dataSource = dataSource
    tableView.reloadData()
    
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    
    XCTAssertNotNil(cell, "Should have a cell.")
  }

  func testTableView_cellIdentifierClosure() {
    let dataSource = ArrayDataSource()
    dataSource.array = [["One"]]
    
    var callCount = 0
    dataSource.cellIdentifier = { (indexPath, item) in
      callCount += 1
      return "id"
    }
    
    let tableView = UITableView()
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")
    tableView.dataSource = dataSource
    tableView.reloadData()
    
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    
    XCTAssertNotNil(cell, "Should have a cell.")
  }
  
  func testTableView_configureCell() {
    let dataSource = ArrayDataSource(defaultCellIdentifier: "id")
    dataSource.array = [["One"]]
    
    var callCount = 0
    
    dataSource.configureCell = { (cell, indexPath, item) in
      XCTAssertEqual(String(item), "One", "Should be 'One'.")
      callCount = callCount + 1
    }
    
    let tableView = UITableView()
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "id")
    tableView.dataSource = dataSource
    tableView.reloadData()
    
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    
    XCTAssertNotNil(cell, "Should have a cell.")
    XCTAssertEqual(callCount, 1, "Should call configureCell 1 time.")
  }
  
}
