/**
 **   NSManagedObjectContext+WPSKit.h
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

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (WPSKit)

#pragma mark - Basic Fetch
- (NSUInteger)wps_countForEntityName:(NSString *)entityName error:(NSError **)error;

- (NSArray *)wps_objectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)descriptors error:(NSError **)error;

- (NSArray *)wps_objectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate limit:(NSUInteger)limit batchSize:(NSUInteger)batchSize sortDescriptors:(NSArray *)descriptors error:(NSError **)error;

- (NSArray *)wps_allObjectsWithEntityName:(NSString *)entityName sortDescriptors:(NSArray *)descriptors error:(NSError **)error;

#pragma mark - Basic Operations

/*
 Returns YES if successful, otherwise returns NO and sets the error.
 */
- (BOOL)wps_saveContext:(NSError **)error;

- (void)wps_saveContextAndParentContextWithCompletionBlock:(void(^)(BOOL success, NSError *error))completion;

@end
