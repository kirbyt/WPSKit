//
//  WPSFetchedResultsDataSource.h
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/1/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPSDataSource.h"

@class NSFetchedResultsController;

@interface WPSFetchedResultsDataSource : NSObject <UICollectionViewDataSource, UITableViewDataSource>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSArray *sectionHeaderTitles;
@property (nonatomic, copy) NSString *cellIdentifier; // Use only if the same cell identifier is used for all cells in all sections.

@property (nonatomic, copy) WPSCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) WPSCellIdentifierBlock cellIdentifierBlock;
@property (nonatomic, copy) WPSCellCanEditBlock canEditBlock;
@property (nonatomic, copy) WPSCellCommitEditingStyleBlock commitEditingStyleBlock;

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/**
 * Helper Methods
 * These helper methods are exposed here so they can be used
 * by subclasses. These methods are intended to NOT be overriden.
 */
- (NSInteger)numberOfSections;
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

@end
