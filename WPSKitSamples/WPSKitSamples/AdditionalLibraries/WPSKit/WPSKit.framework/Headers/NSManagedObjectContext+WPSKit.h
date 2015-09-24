//
// WPSKit
// NSManagedObjectContext+WPSKit.h
//
// Created by Kirby Turner.
// Copyright 2014 White Peak Software. All rights reserved.
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

#import <CoreData/CoreData.h>

/**
 This category adds methods to the Core Data framework’s `NSManagedObjectContext` class. The methods in this category provide support for basic fetch and operations using a managed object context.
 */
@interface NSManagedObjectContext (WPSKit)

#pragma mark - Basic Fetch
/// -----------------
/// @name Basic Fetch
/// -----------------

/**
 Returns the object count for the given entity name.

 @param entityName The name of an entity.
 @param error The error that occurred while attempting count the number of objects.
 
 @return The object count.
 */
- (NSUInteger)wps_countForEntityName:(NSString *)entityName error:(NSError *__autoreleasing *)error;

/**
 Fetches objects from Core Data.
 
 @param entityName The name of an entity.
 @param predicate The predicate used while fetching objects. `nil` specifies no predicate.
 @param descriptors The array of sort descriptors of the receiver. `nil` specifies no sort descriptors.
 @param error If there is a problem executing the fetch, upon return contains an instance of `NSError` that describes the problem.
 
 @return An array of objects that meet the criteria. If an error occurs, returns `nil`. If no objects match the criteria specified by request, returns an empty array.
 */
- (NSArray *)wps_objectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)descriptors error:(NSError *__autoreleasing *)error;

/**
 Fetches objects from Core Data.
 
 @param entityName The name of an entity.
 @param predicate The predicate used while fetching objects. `nil` specifies no predicate.
 @param limit The fetch limit of the receiver. 0 specifies no fetch limit.
 @param batchSize The batch size of the fetch request. A batch size of 0 is treated as infinite, which disables the batch faulting behavior.
 @param descriptors The array of sort descriptors of the receiver. `nil` specifies no sort descriptors.
 @param error If there is a problem executing the fetch, upon return contains an instance of `NSError` that describes the problem.
 
 @return An array of objects that meet the criteria. If an error occurs, returns `nil`. If no objects match the criteria specified by request, returns an empty array.
 */
- (NSArray *)wps_objectsWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate limit:(NSUInteger)limit batchSize:(NSUInteger)batchSize sortDescriptors:(NSArray *)descriptors error:(NSError *__autoreleasing *)error;

/**
 Fetches all objects with the entity name.
 
 @param entityName The name of an entity.
 @param descriptors The array of sort descriptors of the receiver. `nil` specifies no sort descriptors.
 @param error If there is a problem executing the fetch, upon return contains an instance of `NSError` that describes the problem.

 @return An array of all objects with the entity name. If an error occurs, returns `nil`. If no objects match the criteria specified by request, returns an empty array.
 */
- (NSArray *)wps_allObjectsWithEntityName:(NSString *)entityName sortDescriptors:(NSArray *)descriptors error:(NSError *__autoreleasing *)error;

#pragma mark - Basic Operations
/// ----------------------
/// @name Basic Operations
/// ----------------------

/**
 Attempts to commit unsaved changes to registered objects.
 
 @param error A pointer to an NSError object. You do not need to create an NSError object. The save operation aborts after the first failure if you pass NULL.

 @return `YES` if the save succeeds, otherwise `NO`.
 */
- (BOOL)wps_saveContext:(NSError *__autoreleasing *)error;

/**
 Attempts to commit unsaved changes to registered objects, then attempts to save changes to the parent's context.

 @param completion Block that is called after the attempt to save is complete. `success` is `YES` if the save to both the current context and parent context is successful, otherwise `success` is `NO` and an `NSError` instance reporting the error is provided.
 */
- (void)wps_saveContextAndParentContextWithCompletionBlock:(void(^)(BOOL success, NSError *error))completion;

@end
