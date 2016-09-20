//
//  DataSource.swift
//  WPSKit
//
//  Created by Kirby Turner on 4/13/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import UIKit

public protocol DataSource: UICollectionViewDataSource, UITableViewDataSource {
  
  var defaultCellIdentifier: String? {get}
  var sectionHeaderTitles: [String]? {get}
  var configureCell: ((_ cell: AnyObject, _ indexPath: IndexPath, _ item: AnyObject) -> Void)! {get set}
  var cellIdentifier: ((_ indexPath: IndexPath, _ item: AnyObject) -> String)! {get set}
  var canEdit: ((_ indexPath: IndexPath) -> Bool)! {get set}
  var commitEditingStyle: ((_ tableView: UITableView, _ editingStyle: UITableViewCellEditingStyle, _ indexPath: IndexPath) -> Void)! {get set}
  var canMoveItem: ((_ indexPath: IndexPath) -> Bool)! {get set}
  var moveItem: ((_ tableView: UITableView, _ sourceIndexPath: IndexPath, _ destinationIndexPath: IndexPath) -> Void)! {get set}
  var configureSupplementaryView: ((_ view: AnyObject, _ kind: String, _ indexPath: IndexPath) -> Void)! {get set}
  var reuseIdentifierForSupplementaryView: ((_ kind: String, _ indexPath: IndexPath) -> String)! {get set}
  
}
