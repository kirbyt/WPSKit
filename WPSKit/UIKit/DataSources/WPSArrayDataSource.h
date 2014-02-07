//
//  WPSArrayDataSource.h
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/1/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPSDataSource.h"

@interface WPSArrayDataSource : NSObject <UICollectionViewDataSource, UITableViewDataSource>

/**
 Items is an array of arrays.
 The primary array represents the sections, and the seconardary arrays
 represent the rows for the section.
 */
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) NSArray *sectionHeaderTitles;
@property (nonatomic, copy) NSString *cellIdentifier; // Use only if the same cell identifier is used for all cells in all sections.

@property (nonatomic, copy) WPSCellConfigureBlock configureCellBlock;
@property (nonatomic, copy) WPSCellIdentifierBlock cellIdentifierBlock;
@property (nonatomic, copy) WPSCellCanEditBlock canEditBlock;
@property (nonatomic, copy) WPSCellCommitEditingStyleBlock commitEditingStyleBlock;

- (id)initWithArray:(NSArray *)objects cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(WPSCellConfigureBlock)configureCellBlock;
- (id)initWithArray:(NSArray *)objects sectionHeaderTitles:(NSArray *)sectionHeaderTitles cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(WPSCellConfigureBlock)configureCellBlock;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

@end
