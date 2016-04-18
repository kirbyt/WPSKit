//
//  UICollectionViewCellTests.swift
//  WPSKit
//
//  Created by Kirby Turner on 4/17/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import XCTest
import UIKit
@testable import WPSKit

class UICollectionViewCellTests: XCTestCase {
  class FakeCollectionViewCell : UICollectionViewCell {
    
  }
  
  func testCellIdentifier_equalClassName() {
    XCTAssertEqual(FakeCollectionViewCell.cellIdentifier, "FakeCollectionViewCell", "Should match the class name.")
    XCTAssertEqual(UICollectionViewCell.cellIdentifier, "UICollectionViewCell", "Should match the class name.")
  }
  
  func testNibName_shouldEqualClassName() {
    XCTAssertEqual(FakeCollectionViewCell.nibName, "FakeCollectionViewCell")
    XCTAssertEqual(UICollectionViewCell.nibName, "UICollectionViewCell")
  }
  
  func testNib_shouldNotHaveNib() {
    XCTAssertNil(FakeCollectionViewCell.nib, "Should not have a nib.")
  }
  
  func testNib_shouldHaveNib() {
    XCTAssertNotNil(NibBasedCollectionViewCell.nib, "Should have a nib.")
  }
  
  func testCollectionView_registerClass() {
    let dataSource = dataSourceForCellIdentifier(FakeCollectionViewCell.cellIdentifier)
    let collectionView = collectionViewWithDataSource(dataSource)
    
    FakeCollectionViewCell.registerClassWithCollectionView(collectionView)

    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FakeCollectionViewCell.cellIdentifier, forIndexPath: indexPath)
    XCTAssertNotNil(cell, "Should have a cell.")
  }
  
  func testCollectionView_registerNib() {
    let dataSource = dataSourceForCellIdentifier(NibBasedCollectionViewCell.cellIdentifier)
    let collectionView = collectionViewWithDataSource(dataSource)
    
    NibBasedCollectionViewCell.registerNibWithCollectionView(collectionView)

    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NibBasedCollectionViewCell.cellIdentifier, forIndexPath: indexPath)
    XCTAssertNotNil(cell, "Should have a cell.")
  }
}

private extension UICollectionViewCellTests {
  private func dataSourceForCellIdentifier(cellIdentifier: String) -> DataSource {
    
    let dataSource = ArrayDataSource(defaultCellIdentifier: cellIdentifier)
    dataSource.array = [["1", "2", "3"]]
    
    return dataSource
  }
  
  private func collectionViewWithDataSource(dataSource: DataSource) -> UICollectionView {
    
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    collectionView.reloadData()
    
    return collectionView
  }
}
