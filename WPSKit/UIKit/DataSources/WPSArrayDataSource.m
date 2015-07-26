//
//  WPSArrayDataSource.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/1/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import "WPSArrayDataSource.h"
#import "NSArray+WPSKit.h"

@interface WPSArrayDataSource ()

@end

@implementation WPSArrayDataSource

- (id)initWithArray:(NSArray *)array cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(WPSCellConfigureBlock)configureCellBlock
{
   self = [self initWithArray:array sectionHeaderTitles:nil cellIdentifier:cellIdentifier configureCellBlock:configureCellBlock];
   if (self) {
      
   }
   return self;
}

- (id)initWithArray:(NSArray *)array sectionHeaderTitles:(NSArray *)sectionHeaderTitles cellIdentifier:(NSString *)cellIdentifier configureCellBlock:(WPSCellConfigureBlock)configureCellBlock
{
   self = [super init];
   if (self) {
      [self setArray:array];
      [self setSectionHeaderTitles:sectionHeaderTitles];
      [self setCellIdentifier:cellIdentifier];
      [self setConfigureCellBlock:configureCellBlock];
   }
   return self;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath
{
   NSArray *array = [[self array] wps_safeObjectAtIndex:(NSUInteger)[indexPath section]];
   NSUInteger index = (NSUInteger)[indexPath item];
   id object = [array wps_safeObjectAtIndex:index];
   return object;
}

- (NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *cellId = [self cellIdentifier];
   WPSCellIdentifierBlock cellIdentifier = [self cellIdentifierBlock];
   if (cellIdentifier) {
    id item = [self objectAtIndexPath:indexPath];
    cellId = cellIdentifier(indexPath, item);
  }
  return cellId;
}

- (NSString *)reuseIdentifierForSupplementaryViewAtIndexPath:(NSIndexPath *)indexPath kind:(NSString *)kind
{
  NSString *reuseIdentifier = nil;
  if (self.reuseIdentifierForSupplementaryViewBlock) {
    reuseIdentifier = self.reuseIdentifierForSupplementaryViewBlock(kind, indexPath);
  }
  return reuseIdentifier;
}

- (void)addObjects:(NSArray *)array toSection:(NSUInteger)section
{
  NSMutableArray *allObjects = [[self array] mutableCopy];
  NSMutableArray *sectionObjects = [[allObjects wps_safeObjectAtIndex:section] mutableCopy];
  [sectionObjects addObjectsFromArray:array];
  allObjects[section] = sectionObjects;
  
  [self setArray:[allObjects copy]];
}

- (void)insertObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
  NSUInteger section = (NSUInteger)[indexPath section];
  NSUInteger index = (NSUInteger)[indexPath row];
  
  NSMutableArray *allObjects = [[self array] mutableCopy];
  NSMutableArray *sectionObjects = [[allObjects wps_safeObjectAtIndex:section] mutableCopy];
  [sectionObjects insertObject:object atIndex:index];
  allObjects[section] = sectionObjects;
  
  [self setArray:[allObjects copy]];
}

- (void)removeAllObjectsInSection:(NSUInteger)section
{
  NSMutableArray *allObjects = [[self array] mutableCopy];
  [allObjects removeObjectAtIndex:section];
  
  [self setArray:[allObjects copy]];
}

- (void)removeObjectAtIndexPath:(NSIndexPath *)indexPath
{
   NSMutableArray *allObjects = [[self array] mutableCopy];
   NSMutableArray *sectionObjects = [[allObjects wps_safeObjectAtIndex:(NSUInteger)[indexPath section]] mutableCopy];
   NSUInteger index = (NSUInteger)[indexPath item];
   [sectionObjects removeObjectAtIndex:index];
   allObjects[(NSUInteger)[indexPath section]] = sectionObjects;
   
   [self setArray:[allObjects copy]];
}

- (void)replaceAllObjectsInSection:(NSUInteger)section withArray:(NSArray *)array
{
  NSMutableArray *allObjects = [[self array] mutableCopy];
  allObjects[section] = array;
  
  [self setArray:[allObjects copy]];
}

- (void)replaceObjectAtIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
  NSUInteger section = (NSUInteger)[indexPath section];
  NSUInteger index = (NSUInteger)[indexPath row];
  
  NSMutableArray *allObjects = [[self array] mutableCopy];
  NSMutableArray *sectionObjects = [[allObjects wps_safeObjectAtIndex:section] mutableCopy];
  sectionObjects[index] = object;
  allObjects[section] = sectionObjects;
  
  [self setArray:[allObjects copy]];
}

#pragma mark - Helpers

- (NSInteger)numberOfSections
{
   NSInteger count = (NSInteger)[[self array] count];
   return count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
   NSArray *sectionItems = [[self array] wps_safeObjectAtIndex:(NSUInteger)section];
   NSInteger count = (NSInteger)[sectionItems count];
   return count;
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   return [self numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   return [self numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self cellIdentifierAtIndexPath:indexPath] forIndexPath:indexPath];
   if (self.configureCellBlock) {
      id item = [self objectAtIndexPath:indexPath];
      self.configureCellBlock(cell, indexPath, item);
   }
   return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
  NSString *reuseIdentifier = [self reuseIdentifierForSupplementaryViewAtIndexPath:indexPath kind:kind];
  UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  if (self.configureSupplementaryViewBlock) {
    self.configureSupplementaryViewBlock(reusableView, kind, indexPath);
  }
  return reusableView;
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   return [self numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[self cellIdentifierAtIndexPath:indexPath] forIndexPath:indexPath];
   if (self.configureCellBlock) {
      id item = [self objectAtIndexPath:indexPath];
      self.configureCellBlock(cell, indexPath, item);
   }
   return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
   NSString *title = nil;
   NSArray *titles = [self sectionHeaderTitles];
   if (titles) {
      id value = [titles wps_safeObjectAtIndex:(NSUInteger)section];
      if ([value isKindOfClass:[NSString class]]) {
         title = value;
      }
   }
   return title;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
   BOOL canEdit = YES;
   if (self.canEditBlock) {
      canEdit = self.canEditBlock(indexPath);
   }
   return canEdit;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
   if (self.commitEditingStyleBlock) {
      self.commitEditingStyleBlock(tableView, editingStyle, indexPath);
   }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  BOOL canMove = NO;
  if (self.canMoveItemBlock) {
    canMove = self.canMoveItemBlock(indexPath);
  }
  return canMove;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
  if (self.moveItemBlock) {
    self.moveItemBlock(tableView, sourceIndexPath, destinationIndexPath);
  }
}

@end
