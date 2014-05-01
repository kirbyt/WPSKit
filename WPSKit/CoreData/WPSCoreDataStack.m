//
// WPSKit
// WPSCoreDataStack.m
//
// Created by Kirby Turner.
// Copyright 2011 White Peak Software. All rights reserved.
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
// ----------------
// Acknowledgements
// ----------------
//
// This code is based on the PRPBasicDataModel code
// presented in the book iOS Receipts.
// http://pragprog.com/titles/cdirec/ios-recipes
//
// Portions created by Matt Drance.
// Portions copyright 2010 Bookhouse Software, LLC. All rights reserved.
//

#import "WPSCoreDataStack.h"

static void wps_runOnMainQueueWithoutDeadlocking(void (^block)(void))
{
  /*
   Run on the main thread without causing a deadlock.
   This function is from Brad Larson, who posted it at:
   http://stackoverflow.com/questions/5225130/grand-central-dispatch-gcd-vs-performselector-need-a-better-explanation/5226271#5226271
   */
  if ([NSThread isMainThread])
  {
    block();
  }
  else
  {
    dispatch_sync(dispatch_get_main_queue(), block);
  }
}

@interface WPSCoreDataStack ()
- (NSString *)documentsDirectory;
@end


@implementation WPSCoreDataStack

@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize mainManagedObjectContext = _mainManagedObjectContext;
@synthesize childManagedObjectContext = _childManagedObjectContext;

- (id)init
{
  self = [super init];
  if (self) {
    [self setMigrateStoreIfNeeded:YES];
  }
  return self;
}

#pragma mark - Filesystem hooks

- (NSString *)modelName
{
  return [[[NSBundle mainBundle] bundleIdentifier] pathExtension];
}

- (NSString *)pathToModel
{
  NSString *filename = [self modelName];
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *localModelPath = [mainBundle pathForResource:filename ofType:@"momd"];
  if (localModelPath == nil) {
    localModelPath = [mainBundle pathForResource:filename ofType:@"mom"];
  }
  NSAssert2(localModelPath, @"Could not find '%@.momd' or '%@.mom'", filename, filename);
  return localModelPath;
}

- (NSString *)storeFileName
{
  return [[self modelName] stringByAppendingPathExtension:@"sqlite"];
}

- (NSString *)pathToLocalStore
{
  NSString *storeName = [self storeFileName];
  NSString *docPath = [self documentsDirectory];
  return [docPath stringByAppendingPathComponent:storeName];
}

- (NSString *)pathToDefaultStore
{
  NSString *storeName = [self storeFileName];
  return [[NSBundle mainBundle] pathForResource:storeName ofType:nil];
}

#pragma mark - Persistent Store Coordinator Info

- (NSDictionary *)persistentStoreOptions
{
  NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                           [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                           nil];
  return options;
}

- (NSString *)persistentStoreConfiguration
{
  return nil;
}

#pragma mark - Core Data Stack

- (NSManagedObjectContext *)mainManagedObjectContext
{
  if (_mainManagedObjectContext == nil) {
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
      _mainManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
      [_mainManagedObjectContext performBlockAndWait:^{
        [_mainManagedObjectContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        [_mainManagedObjectContext setPersistentStoreCoordinator:coordinator];
      }];
    }
  }
  
  return _mainManagedObjectContext;
}

- (NSManagedObjectContext *)childManagedObjectContext
{
  if (_childManagedObjectContext != nil) {
    return _childManagedObjectContext;
  }
  
  // Make sure we create the child context on the main thread.
  NSManagedObjectContext *mainContext = [self mainManagedObjectContext];
  wps_runOnMainQueueWithoutDeadlocking(^{
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
      _childManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
      [_childManagedObjectContext setParentContext:mainContext];
    }
  });

  return _childManagedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
  if (_managedObjectModel == nil) {
    NSURL *storeURL = [NSURL fileURLWithPath:[self pathToModel]];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:storeURL];
  }
  return _managedObjectModel;
}

- (void)preinstallDefaultDatabase
{
  // Copy the default DB from the app bundle if none exists (either
  // first launch or just removed above)
  NSString *pathToLocalStore = [self pathToLocalStore];
  NSString *pathToDefaultStore = [self pathToDefaultStore];
  NSError *error = nil;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  BOOL noLocalDBExists = ![fileManager fileExistsAtPath:pathToLocalStore];
  BOOL defaultDBExists = [fileManager fileExistsAtPath:pathToDefaultStore];
  if (noLocalDBExists && defaultDBExists) {
    if (![[NSFileManager defaultManager] copyItemAtPath:pathToDefaultStore toPath:pathToLocalStore error:&error]) {
      NSLog(@"Error copying default DB to %@ (%@)", pathToLocalStore, error);
    }
  }
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
  if (_persistentStoreCoordinator == nil) {
    NSURL *storeURL = [NSURL fileURLWithPath:[self pathToLocalStore]];
    
    NSError *error = nil;
    NSManagedObjectModel *model = [self managedObjectModel];
    BOOL success = [self progressivelyMigrateURL:storeURL ofType:NSSQLiteStoreType toModel:model error:&error];
    if (!success && error) {
      // TODO: Alert the user.
      NSLog(@"Migration error: %@", [error localizedDescription]);
    }
    
    NSPersistentStoreCoordinator *coordinator;
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSDictionary *options = [self persistentStoreOptions];
    NSString *configuration = [self persistentStoreConfiguration];
    
    error = nil;
    if (![coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:configuration URL:storeURL options:options error:&error]) {
      NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
      NSException *exc = nil;
      NSString *reason = @"Could not create persistent store.";
      exc = [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:userInfo];
      @throw exc;
    }
    _persistentStoreCoordinator = coordinator;
  }
  
  return _persistentStoreCoordinator;
}

#pragma mark - Helpers

- (NSString *)documentsDirectory
{
  NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
  if (![[NSFileManager defaultManager] fileExistsAtPath:docDir]) {
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:docDir
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
      NSString *errorMsg = @"Could not find or create a Documents directory.";
      NSDictionary *errorInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
      NSException *directoryException = [NSException exceptionWithName:NSInternalInconsistencyException
                                                                reason:errorMsg
                                                              userInfo:errorInfo];
      
      @throw directoryException;
    }
  }
  return docDir;
}

#pragma mark - Progressive Migration -

- (BOOL)progressivelyMigrateURL:(NSURL*)sourceStoreURL ofType:(NSString*)type toModel:(NSManagedObjectModel*)finalModel error:(NSError *__autoreleasing *)error
{
  NSDictionary *sourceMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:type URL:sourceStoreURL error:error];
  if (!sourceMetadata) {
    if (error != NULL) {
      *error = nil;
    }
    return NO;
  }
  
  if ([finalModel isConfiguration:nil compatibleWithStoreMetadata:sourceMetadata]) {
    if (error != NULL) {
      *error = nil;
    }
    return YES;
  }
  
  //Find the source model
  NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:nil forStoreMetadata:sourceMetadata];
  NSAssert(sourceModel != nil, @"Failed to find source model\n%@", sourceMetadata);
  
  //Find all of the mom and momd files in the Resources directory
  NSMutableArray *modelPaths = [NSMutableArray array];
  NSArray *momdArray = [[NSBundle mainBundle] pathsForResourcesOfType:@"momd" inDirectory:nil];
  for (NSString *momdPath in momdArray) {
    NSString *resourceSubpath = [momdPath lastPathComponent];
    NSArray *array = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom" inDirectory:resourceSubpath];
    [modelPaths addObjectsFromArray:array];
  }
  NSArray* otherModels = [[NSBundle mainBundle] pathsForResourcesOfType:@"mom" inDirectory:nil];
  [modelPaths addObjectsFromArray:otherModels];
  if (!modelPaths || ![modelPaths count]) {
    //Throw an error if there are no models
    NSDictionary *dict = @{NSLocalizedDescriptionKey:@"No models found in bundle."};
    if (error != NULL) {
      *error = [NSError errorWithDomain:@"PhotoWheel" code:8001 userInfo:dict];
    }
    return NO;
  }
  
  //See if we can find a matching destination model
  NSMappingModel *mappingModel = nil;
  NSManagedObjectModel *targetModel = nil;
  NSString *modelPath = nil;
  for (modelPath in modelPaths) {
    targetModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:modelPath]];
    mappingModel = [NSMappingModel mappingModelFromBundles:nil forSourceModel:sourceModel destinationModel:targetModel];
    //If we found a mapping model then proceed
    if (mappingModel) {
      break;
    }
  }
  //We have tested every model, if nil here we failed
  if (!mappingModel) {
    NSDictionary *dict = @{NSLocalizedDescriptionKey:@"No models found in bundle."};
    if (error != NULL) {
      *error = [NSError errorWithDomain:@"PhotoWheel" code:8001 userInfo:dict];
    }
    return NO;
  }
  //We have a mapping model and a destination model.  Time to migrate
  NSMigrationManager *manager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:targetModel];
  NSString *modelName = [[modelPath lastPathComponent] stringByDeletingPathExtension];
  NSString *storeExtension = [[sourceStoreURL path] pathExtension];
  NSString *storePath = [[sourceStoreURL path] stringByDeletingPathExtension];
  //Build a path to write the new store
  storePath = [NSString stringWithFormat:@"%@.%@.%@", storePath, modelName, storeExtension];
  NSURL *destinationStoreURL = [NSURL fileURLWithPath:storePath];
  if (![manager migrateStoreFromURL:sourceStoreURL
                               type:type
                            options:nil
                   withMappingModel:mappingModel
                   toDestinationURL:destinationStoreURL
                    destinationType:type
                 destinationOptions:nil
                              error:error]) {
    return NO;
  }
  //Migration was successful, move the files around to preserve the source
  NSString *guid = [[NSProcessInfo processInfo] globallyUniqueString];
  guid = [guid stringByAppendingPathExtension:modelName];
  guid = [guid stringByAppendingPathExtension:storeExtension];
  NSString *appSupportPath = [storePath stringByDeletingLastPathComponent];
  NSString *backupPath = [appSupportPath stringByAppendingPathComponent:guid];
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if (![fileManager moveItemAtPath:[sourceStoreURL path] toPath:backupPath error:error]) {
    //Failed to copy the file
    return NO;
  }
  //Move the destination to the source path
  if (![fileManager moveItemAtPath:storePath toPath:[sourceStoreURL path] error:error]) {
    //Try to back out the source move first, no point in checking it for errors
    [fileManager moveItemAtPath:backupPath toPath:[sourceStoreURL path] error:nil];
    return NO;
  }
  //We may not be at the "current" model yet, so recurse
  return [self progressivelyMigrateURL:sourceStoreURL ofType:type toModel:finalModel error:error];
}

@end
