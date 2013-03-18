/**
 **   WPSManagedObjectContextWatcher.m
 **
 **   Created by Kirby Turner.
 **   Copyright (c) 2013 White Peak Software. All rights reserved.
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
 **
 **   This work is derived from ZSContextWatcher.
 **   Copyright 2010 Zarra Studios, LLC All rights reserved.
 **/

#import "WPSManagedObjectContextWatcher.h"

@implementation WPSManagedObjectContextWatcher

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)context;
{
   NSParameterAssert(context);

   self = [super init];
   if (self) {
      NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
      [nc addObserver:self selector:@selector(contextUpdated:) name:NSManagedObjectContextDidSaveNotification object:nil];
      [self setPersistentStoreCoordinator:[context persistentStoreCoordinator]];
   }
   return self;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext*)context target:(id)target action:(SEL)action
{
    self = [self initWithManagedObjectContext:context];
    if (self) {
        [self setTarget:target];
        [self setAction:action];
    }
    return self;
}

- (void) dealloc
{
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
   [nc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
}

- (void)addEntityToWatch:(NSEntityDescription*)description withPredicate:(NSPredicate*)predicate
{
   NSPredicate *entityPredicate = [NSPredicate predicateWithFormat:@"entity.name == %@", [description name]];
   NSPredicate *finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithObjects:entityPredicate, predicate, nil]];
   
   if (![self masterPredicate]) {
      [self setMasterPredicate:finalPredicate];
      return;
   }
   
   NSArray *array = [[NSArray alloc] initWithObjects:[self masterPredicate], finalPredicate, nil];
   finalPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:array];
   [self setMasterPredicate:finalPredicate];
}

- (void)contextUpdated:(NSNotification*)notification
{
   NSManagedObjectContext *incomingContext = [notification object];
   NSPersistentStoreCoordinator *incomingCoordinator = [incomingContext persistentStoreCoordinator];
   if (incomingCoordinator != [self persistentStoreCoordinator]) {
      return;
   }
#if DEBUG
   if ([self reference]) {
      NSLog(@"%@ entered", [self reference]);
   }
#endif
   NSDictionary *userInfo = [notification userInfo];
   NSMutableSet *inserted = [[userInfo objectForKey:NSInsertedObjectsKey] mutableCopy];
   if ([self masterPredicate]) {
      [inserted filterUsingPredicate:[self masterPredicate]];
   }
   NSMutableSet *deleted = [[userInfo objectForKey:NSDeletedObjectsKey] mutableCopy];
   if ([self masterPredicate]) {
      [deleted filterUsingPredicate:[self masterPredicate]];
   }
   NSMutableSet *updated = [[userInfo objectForKey:NSUpdatedObjectsKey] mutableCopy];
   if ([self masterPredicate]) {
      [updated filterUsingPredicate:[self masterPredicate]];
   }
   
   NSInteger totalCount = [inserted count] + [deleted count]  + [updated count];
   if (totalCount == 0) {
#if DEBUG
      if ([self reference]) {
         NSLog(@"%@----------fail on count", [self reference]);
      }
#endif
      return;
   }
   
   NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
   if (inserted) {
      [results setObject:inserted forKey:NSInsertedObjectsKey];
   }
   if (deleted) {
      [results setObject:deleted forKey:NSDeletedObjectsKey];
   }
   if (updated) {
      [results setObject:updated forKey:NSUpdatedObjectsKey];
   }
   
   if ([[self target] respondsToSelector:[self action]]) {
#if DEBUG
      if ([self reference]) {
         NSLog(@"%@++++++++++firing action", [self reference]);
      }
#endif
      [[self target] performSelectorOnMainThread:[self action] withObject:results waitUntilDone:YES];
   } else {
#if DEBUG
      if ([self reference]) {
         NSLog(@"%@----------target doesn't respond to action", [self reference]);
      }
#endif
   }
}

@end
