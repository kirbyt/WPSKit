/**
 **   NSManagedObjectContext+WPSKit.m
 **
 **   Created by Kirby Turner.
 **   Copyright (c) 2014 White Peak Software. All rights reserved.
 **
 **   Permission is hereby granted, free of charge, to any person obtaining
 **   a copy of this software and associated documentation files (the
 **   "Software"), to deal in the Software without restriction, including
 **   without limitation the rights to use, copy, modify, merge, publish,
 **   distribute, sublicense, and/or sell copies of the Software, and to permit
 **   persons to whom the Software is furnished to do so, subject to the
 **   following conditions:
 **
 **   The above copyright notice and this permission notice shall be included
 **   in all copies or substantial portions of the Software.
 **
 **   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 **   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 **   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 **   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 **   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 **   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 **   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **
 **/

#import "NSManagedObjectContext+WPSKit.h"

@implementation NSManagedObjectContext (WPSKit)

#pragma mark - Basic Fetching

- (NSUInteger)wps_countForEntityName:(NSString *)entityName error:(NSError **)error
{
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
  NSUInteger count = [self countForFetchRequest:request error:error];
  return count;
}

- (NSArray *)wps_objectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)descriptors error:(NSError **)error
{
  return [self wps_objectsWithEntityName:entityName predicate:predicate limit:0 batchSize:0 sortDescriptors:descriptors error:error];
}

- (NSArray *)wps_objectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate limit:(NSUInteger)limit batchSize:(NSUInteger)batchSize sortDescriptors:(NSArray *)descriptors error:(NSError **)error
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self]];
  [request setSortDescriptors:descriptors];
  [request setFetchLimit:limit];
  [request setFetchBatchSize:batchSize];
  [request setPredicate:predicate];
  NSArray *results = [self executeFetchRequest:request error:error];
  
  return results;
}

- (NSArray *)wps_allObjectsWithEntityName:(NSString *)entityName sortDescriptors:(NSArray *)descriptors error:(NSError **)error
{
  return [self wps_objectsWithEntityName:entityName predicate:nil limit:0 batchSize:0 sortDescriptors:descriptors error:error];
}

#pragma mark - Basic Operations

- (BOOL)wps_saveContext:(NSError **)error
{
  BOOL success = YES;
  if ([self hasChanges] && ![self save:error])
  {
    success = NO;
  }
  return success;
}

- (void)wps_saveContextAndParentContextWithCompletionBlock:(void(^)(BOOL success, NSError *error))completion
{
  NSError *childError = nil;
  if ([self wps_saveContext:&childError]) {
    NSManagedObjectContext *parentContext = [self parentContext];
    if (parentContext) {
      [parentContext performBlockAndWait:^{
        NSError *parentError = nil;
        BOOL success = [parentContext save:&parentError];
        if (completion) {
          completion(success, parentError);
        }
      }];
    } else {
      if (completion) {
        completion(YES, childError);
      }
    }
  } else {
    if (completion) {
      completion(NO, childError);
    }
  }
}

@end
