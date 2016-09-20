//
//  ArrayDataSource.swift
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

import UIKit

public class ArrayDataSource: NSObject, DataSource {
  
  public var array:[[AnyObject]] = [[]]
  
  public let defaultCellIdentifier: String?

  public let sectionHeaderTitles: [String]?
  
  public var configureCell: ((_ cell: AnyObject, _ indexPath: IndexPath, _ item: AnyObject) -> Void)!
  
  public var cellIdentifier: ((_ indexPath: IndexPath, _ item: AnyObject) -> String)!
  
  public var canEdit: ((_ indexPath: IndexPath) -> Bool)!
  
  public var commitEditingStyle: ((_ tableView: UITableView, _ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> Void)!
  
  public var canMoveItem: ((_ indexPath: IndexPath) -> Bool)!
  
  public var moveItem: ((_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)!
  
  public var configureSupplementaryView: ((_ view: AnyObject, _ kind: String, _ indexPath: IndexPath) -> Void)!
  
  public var reuseIdentifierForSupplementaryView: ((_ kind: String, _ indexPath: IndexPath) -> String)!

  public init(defaultCellIdentifier: String? = nil, sectionHeaderTitles: [String]? = nil) {
    self.defaultCellIdentifier = defaultCellIdentifier
    self.sectionHeaderTitles = sectionHeaderTitles
  }
}

// MARK: - DataSource Public

public extension ArrayDataSource {
  
  /**
   Returns the object found at the provided index path.
   
   - parameter indexPath: The index path to the object.
   
   - return Returns the object.
   */
  public func objectAtIndexPath(_ indexPath: IndexPath) -> AnyObject? {
    guard (indexPath as NSIndexPath).section < array.count else {
      return nil
    }
    
    guard (indexPath as NSIndexPath).row < array[(indexPath as NSIndexPath).section].count else {
      return nil
    }
    
    return array[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
  }
  
}

// MARK: - DataSource Private

private extension ArrayDataSource {
  
  func numberOfSections() -> Int {
    return array.count
  }
  
  func numberOfRowsInSection(_ section: Int) -> Int {
    guard section < array.count else {
      return 0
    }
    
    return array[section].count
  }

  func cellIdentifierAtIndexPath(_ indexPath: IndexPath) -> String {
    var id = defaultCellIdentifier
    if let cellIdentifier = cellIdentifier {
      if let item = objectAtIndexPath(indexPath) {
        id = cellIdentifier(indexPath, item)
      }
    }
    if id == nil {
      fatalError("You did not set the cell identifier!")
    }
    return id!
  }
  
  func reuseIdentifierForSupplementaryViewAtIndexPath(_ indexPath: IndexPath, kind: String) -> String {
    return reuseIdentifierForSupplementaryView(kind, indexPath)
  }
  
}

// MARK: - UICollectionViewDataSource

extension ArrayDataSource {

  @objc(numberOfSectionsInCollectionView:) public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return numberOfSections()
  }
  
  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfRowsInSection(section)
  }
  
  @objc(collectionView:cellForItemAtIndexPath:) public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let identifier = cellIdentifierAtIndexPath(indexPath)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    if let configureCell = configureCell {
      let item = objectAtIndexPath(indexPath)
      configureCell(cell, indexPath, item!)
    }
    return cell
  }
  
  @objc(collectionView:viewForSupplementaryElementOfKind:atIndexPath:) public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let reuseIdentifier = reuseIdentifierForSupplementaryViewAtIndexPath(indexPath, kind: kind)
    let reusableView = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    if let configureSupplementaryView = configureSupplementaryView {
      configureSupplementaryView(reusableView, kind, indexPath)
    }
    
    return reusableView
  }
}

// MARK: - UITableViewDataSource

extension ArrayDataSource {
  
  @objc(numberOfSectionsInTableView:) public func numberOfSections(in tableView: UITableView) -> Int {
    return numberOfSections()
  }
  
  public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfRowsInSection(section)
  }
  
  @objc(tableView:cellForRowAtIndexPath:) public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let identifier = cellIdentifierAtIndexPath(indexPath)
    let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    if let configureCell = configureCell {
      let item = objectAtIndexPath(indexPath)
      configureCell(cell, indexPath, item!)
    }
    return cell
  }
  
  public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    guard let titles = sectionHeaderTitles else {
      return nil
    }
    
    guard section < titles.count else {
      return nil
    }
    
    return titles[section]
  }
  
  @objc(tableView:canEditRowAtIndexPath:) public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    var edit = false
    if let canEdit = canEdit {
      edit = canEdit(indexPath)
    }
    return edit
  }

  public func tableView(_ tableView: UITableView, editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
    if let commitEditingStyle = commitEditingStyle {
      commitEditingStyle(tableView, editingStyle, indexPath)
    }
  }
  
  @objc(tableView:canMoveRowAtIndexPath:) public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    var canMove = false
    if let canMoveItem = canMoveItem {
      canMove = canMoveItem(indexPath)
    }
    return canMove
  }

  @objc(tableView:moveRowAtIndexPath:toIndexPath:) public func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    if let moveItem = moveItem {
      moveItem(tableView, sourceIndexPath, destinationIndexPath)
    }
  }
}
