//
//  UICollectionReusableViewTests.swift
//  WPSKit
//
//  Created by Kirby Turner on 4/18/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import XCTest
import UIKit
@testable import WPSKit

class UICollectionReusableViewTests: XCTestCase {

  class FakeCollectionReusableView : UICollectionReusableView {
    
  }
  
  func testCellIdentifier_equalClassName() {
    XCTAssertEqual(FakeCollectionReusableView.cellIdentifier, "FakeCollectionReusableView", "Should match the class name.")
  }
  
  func testNibName_shouldEqualClassName() {
    XCTAssertEqual(FakeCollectionReusableView.nibName, "FakeCollectionReusableView")
  }
  
  func testNib_shouldNotHaveNib() {
    XCTAssertNil(FakeCollectionReusableView.nib, "Should not have a nib.")
  }
  
  func testNib_shouldHaveNib() {
    XCTAssertNotNil(NibBasedCollectionViewCell.nib, "Should have a nib.")
  }

  // TODO: Figure out why these tests thing there is no section data.
//  func testCollectionView_registerClass() {
//    let dataSource = dataSourceForReuseIdentifier(FakeCollectionReusableView.cellIdentifier)
//    let collectionView = collectionViewWithDataSource(dataSource)
//    
//    FakeCollectionReusableView.registerClassForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withCollectionView: collectionView)
//    
//    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
//    let cell = collectionView.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
////    let cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: FakeCollectionReusableView.cellIdentifier, forIndexPath: indexPath)
//    XCTAssertNotNil(cell, "Should have a cell.")
//  }
  
//  func testCollectionView_registerNib() {
//    let dataSource = dataSourceForReuseIdentifier(NibBasedCollectionViewCell.cellIdentifier)
//    let collectionView = collectionViewWithDataSource(dataSource)
//    
//    NibBasedCollectionViewCell.registerNibForSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withCollectionView: collectionView)
//    
//    let indexPath = NSIndexPath(forItem: 0, inSection: 0)
//    let cell = collectionView.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: indexPath)
////    let cell = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: NibBasedCollectionViewCell.cellIdentifier, forIndexPath: indexPath)
//    XCTAssertNotNil(cell, "Should have a cell.")
//  }
}

private extension UICollectionReusableViewTests {
  func dataSourceForReuseIdentifier(_ reuseIdentifier: String) -> DataSource {
    
    let dataSource = ArrayDataSource()
    dataSource.array = [["1" as AnyObject, "2" as AnyObject, "3" as AnyObject], ["1" as AnyObject, "2" as AnyObject, "3" as AnyObject]]
    dataSource.reuseIdentifierForSupplementaryView = { (kind, indexPath) -> String in
      return reuseIdentifier
    }
    
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
