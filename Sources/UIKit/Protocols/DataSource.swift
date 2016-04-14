//
//  DataSource.swift
//  WPSKit
//
//  Created by Kirby Turner on 4/13/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
//

import UIKit

public protocol DataSource {
  
  var defaultCellIdentifier: String? {get}
  var sectionHeaderTitles: [String]? {get}
  var configureCell: ((cell: AnyObject, indexPath: NSIndexPath, item: AnyObject) -> Void)! {get set}
  var cellIdentifier: ((indexPath: NSIndexPath, item: AnyObject) -> String)! {get set}
  var canEdit: ((indexPath: NSIndexPath) -> Bool)! {get set}
  var commitEditingStyle: ((tableView: UITableView, editingStyle: UITableViewCellEditingStyle, indexPath: NSIndexPath) -> Void)! {get set}
  var canMoveItem: ((indexPath: NSIndexPath) -> Bool)! {get set}
  var moveItem: ((tableView: UITableView, sourceIndexPath: NSIndexPath, destinationIndexPath: NSIndexPath) -> Void)! {get set}
  var configureSupplementaryView: ((view: AnyObject, kind: String, indexPath: NSIndexPath) -> Void)! {get set}
  var reuseIdentifierForSupplementaryView: ((kind: String, indexPath: NSIndexPath) -> String)! {get set}
  
}
