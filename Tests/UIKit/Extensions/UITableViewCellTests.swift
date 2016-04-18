//
//  UITableViewCellTests.swift
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
import UIKit
@testable import WPSKit

class UITableViewCellTests: XCTestCase {
  class FakeTableViewCell : UITableViewCell {
    
  }

  func testCellIdentifier_equalClassName() {
    XCTAssertEqual(FakeTableViewCell.cellIdentifier, "FakeTableViewCell", "Should match the class name.")
    XCTAssertEqual(UITableViewCell.cellIdentifier, "UITableViewCell", "Should match the class name.")
  }
  
  func testNibName_shouldEqualClassName() {
    XCTAssertEqual(FakeTableViewCell.nibName, "FakeTableViewCell")
    XCTAssertEqual(UITableViewCell.nibName, "UITableViewCell")
  }

  func testNib_shouldNotHaveNib() {
    XCTAssertNil(FakeTableViewCell.nib, "Should not have a nib.")
  }

  func testNib_shouldHaveNib() {
    XCTAssertNotNil(NibBasedTableViewCell.nib, "Should have a nib.")
  }
  
  func testTableView_registerClass() {
    let tableView = UITableView()
    FakeTableViewCell.registerClassWithTableView(tableView)
  }
  
  func testTableView_registerNib() {
    let dataSource = dataSourceForCellIdentifier(NibBasedTableViewCell.cellIdentifier)
    let tableView = tableViewWithDataSource(dataSource)
    
    NibBasedTableViewCell.registerNibWithTableView(tableView)
    let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
    XCTAssertNotNil(cell, "Should have a table view cell.")
  }
}

private extension UITableViewCellTests {
  private func dataSourceForCellIdentifier(cellIdentifier: String) -> DataSource {

    let dataSource = ArrayDataSource(defaultCellIdentifier: cellIdentifier)
    dataSource.array = [["1", "2", "3"]]
    
    return dataSource
  }
  
  private func tableViewWithDataSource(dataSource: DataSource) -> UITableView {
    
    let tableView = UITableView()
    tableView.dataSource = dataSource
    tableView.reloadData()

    return tableView
  }
}