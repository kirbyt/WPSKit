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

    let indexPath = IndexPath(item: 0, section: 0)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FakeCollectionViewCell.cellIdentifier, for: indexPath)
    XCTAssertNotNil(cell, "Should have a cell.")
  }
  
  func testCollectionView_registerNib() {
    let dataSource = dataSourceForCellIdentifier(NibBasedCollectionViewCell.cellIdentifier)
    let collectionView = collectionViewWithDataSource(dataSource)
    
    NibBasedCollectionViewCell.registerNibWithCollectionView(collectionView)

    let indexPath = IndexPath(item: 0, section: 0)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NibBasedCollectionViewCell.cellIdentifier, for: indexPath)
    XCTAssertNotNil(cell, "Should have a cell.")
  }
}

private extension UICollectionViewCellTests {
  func dataSourceForCellIdentifier(_ cellIdentifier: String) -> DataSource {
    
    let dataSource = ArrayDataSource(defaultCellIdentifier: cellIdentifier)
    dataSource.array = [["1" as AnyObject, "2" as AnyObject, "3" as AnyObject]]
    
    return dataSource
  }
  
  func collectionViewWithDataSource(_ dataSource: DataSource) -> UICollectionView {
    
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    collectionView.dataSource = dataSource
    collectionView.reloadData()
    
    return collectionView
  }
}
