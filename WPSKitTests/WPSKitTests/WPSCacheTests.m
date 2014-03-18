/**
 **   WPSCacheTests
 **
 **   Created by Kirby Turner.
 **   Copyright 2011 White Peak Software. All rights reserved.
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

#import "WPSCacheTests.h"
#import "WPSCache.h"
#import "NSString+WPSKit.h"

@interface WPSCacheTests ()
@property (nonatomic, strong) WPSCache *cache;
@end

@implementation WPSCacheTests

@synthesize cache = _cache;

- (void)setUp
{
   [self setCache:[[WPSCache alloc] init]];
}

- (void)testCache
{
   WPSCache *cache = [self cache];
   
   NSString *key = @"cachedData";
   NSString *string = @"This is a test of the WPSCache class.";
   NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
   [cache cacheData:data forKey:key cacheLocation:WPSCacheLocationMemory];
   
   NSData *cachedData = [cache dataForKey:key];
   NSString *stringToMatch = [NSString wps_stringWithData:cachedData encoding:NSUTF8StringEncoding];
   STAssertTrue([string isEqualToString:stringToMatch], @"Unexpected string value.");
   
   [cache flushCache];
   cachedData = [cache dataForKey:key];
   STAssertNil(cachedData, @"Returned an unexpected cached item.");
   
   [cache cacheData:data forKey:key cacheLocation:WPSCacheLocationFileSystem];
   cachedData = [cache dataForKey:key];
   stringToMatch = [NSString wps_stringWithData:cachedData encoding:NSUTF8StringEncoding];
   STAssertTrue([string isEqualToString:stringToMatch], @"String value '%@' does not match '%@'.", string, stringToMatch);
   
   NSURL *fileURL = [cache fileURLForKey:key];
   STAssertNotNil(fileURL, @"Unassigned file URL for cached item.");
   
   cachedData = [cache dataForKey:key];
   stringToMatch = [NSString wps_stringWithData:cachedData encoding:NSUTF8StringEncoding];
   STAssertTrue([string isEqualToString:stringToMatch], @"Unexpected string value.");

   [cache flushFileSystemCache];
   cachedData = [cache dataForKey:key];
   STAssertNil(cachedData, @"Received an unexpected cached item.");
   fileURL = [cache fileURLForKey:key];
   STAssertNil(fileURL, @"Received an unexpected file URL for an cached item that should not exist.");

   /////
   // Test the memory and file system caches are separate.
   [cache cacheData:data forKey:key cacheLocation:WPSCacheLocationMemory|WPSCacheLocationFileSystem];
   fileURL = [cache fileURLForKey:key];
   STAssertNotNil(fileURL, @"Received an unassigned file URL for cached item.");
   [cache flushFileSystemCache];
   fileURL = [cache fileURLForKey:key];
   STAssertNil(fileURL, @"Received an unexpected file URL for an cached item that should not exist.");
   cachedData = [cache dataForKey:key];
   stringToMatch = [NSString wps_stringWithData:cachedData encoding:NSUTF8StringEncoding];
   STAssertTrue([string isEqualToString:stringToMatch], @"Unexpected string value.");
}

- (void)testCleanStaleCacheFromFileSystem
{
  WPSCache *cache = [self cache];
  
  NSString *key = @"cachedData";
  NSString *string = @"This is a test of the WPSCache class.";
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
  // Cache the data to the file system making it stale as soon as possible.
  [cache cacheData:data forKey:key cacheLocation:WPSCacheLocationFileSystem cacheAge:1.0f];

  NSData *cacheData = [cache dataForKey:key];
  STAssertNotNil(cacheData, @"Missing cached data.");

  [NSThread sleepForTimeInterval:2.0f];
  
  [cache cleanStaleCacheFromFileSystemWithCompletion:^{
    NSData *data = [cache dataForKey:key];
    STAssertNil(data, @"Received an unexpected cached item.");
  }];
}

@end
