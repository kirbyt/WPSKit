//
//  WPSDataSource.h
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/1/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#ifndef WPSKitSamples_WPSDataSource_h
#define WPSKitSamples_WPSDataSource_h

typedef void (^WPSCellConfigureBlock)(id cell, NSIndexPath *indexPath, id item);
typedef NSString * (^WPSCellIdentifierBlock)(NSIndexPath *indexPath);
typedef BOOL (^WPSCellCanEditBlock)(NSIndexPath *indexPath);
typedef void (^WPSCellCommitEditingStyleBlock)(UITableView *tableView, UITableViewCellEditingStyle editingStyle, NSIndexPath *indexPath);

typedef BOOL (^WPSCellCanMoveItemBlock)(NSIndexPath *indexPath);
typedef void (^WPSCellMoveItemBlock)(UITableView *tableView, NSIndexPath *sourceIndexPath, NSIndexPath *destinationIndexPath);

#endif
