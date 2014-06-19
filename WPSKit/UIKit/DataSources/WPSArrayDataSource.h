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

/**
 Returns the object found at the provided index path.
 
 @param indexPath The index path to the object.
 @return Returns the object.
 */
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

/**
 Adds an array of objects to the speified section.
 
 @param array An array of objects to add to the section.
 @param section The section to which the objects are added.
 */
- (void)addObjects:(NSArray *)array toSection:(NSUInteger)section;

/**
 Inserts an object at the provided index path.
 
 @param object The object to add. Value must not be `nil`.
 @param indexPath The index path where the object is inserted.
 */
- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

/**
 Removes all objects in the specified section.
 
 @param section The section from which the objects are removed.
 */
- (void)removeAllObjectsInSection:(NSUInteger)section;

/** 
 Removes the object at the provided index path.
 
 @param indexPath The index path to the object that is removed.
 */
- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath;

/**
 Replaces all objects in the provided section with the array of objects.
 
 @param section The index to the section.
 @param array The new objects for the section.
 */
- (void)replaceAllObjectsInSection:(NSUInteger)section withArray:(NSArray *)array;

/**
 Replaces the object at the provided index path with the provided object.
 
 @param indexPath The index path to the object to replace.
 @param object The object that replaces the previous object.
 */
- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object;

/**
 Returns the cell identifier for the cell at the provided index path.

 @param indexPath The index path to the cell.
 @return Returns a string representing the cell identifier.
*/
- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath;

@end
