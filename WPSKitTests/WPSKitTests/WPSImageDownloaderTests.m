/**
 **   WPSImageDownloaderTests
 **
 **   Created by Kirby Turner.
 **   Copyright (c) 2011 White Peak Software. All rights reserved.
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

#import "WPSImageDownloaderTests.h"
#import "WPSImageDownloader.h"
#import "WPSCache.h"

@implementation WPSImageDownloaderTests

- (void)testWithoutCache
{
   __block BOOL done = NO;
   WPSImageDownloaderCompletionBlock completion = ^(UIImage *image, NSURL *URL, NSError *error) {
      XCTAssertNotNil(image, @"Received nil image.");
      XCTAssertNil(error, @"Received error: %@", [error localizedDescription]);
      done = YES;
   };
   
   NSURL *URL = [NSURL URLWithString:@"http://farm5.static.flickr.com/4027/4438046129_1ef4a244bd_o.png"];
   WPSImageDownloader *downloader = [[WPSImageDownloader alloc] init];
   [downloader downloadImageAtURL:URL completion:completion];
   
   // Wait until the request finishes.
   while (!done) {
      // This executes another run loop.
      [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
      // Sleep 1/100th sec
      usleep(10000);
   }
}

- (void)testWithCache
{
   WPSCache *cache = [[WPSCache alloc] init];
   NSURL *URL = [NSURL URLWithString:@"http://farm5.static.flickr.com/4027/4438046129_1ef4a244bd_o.png"];

   __block BOOL done = NO;
   WPSImageDownloaderCompletionBlock completion = ^(UIImage *image, NSURL *URL, NSError *error) {
      XCTAssertNotNil(image, @"Received nil image.");
      XCTAssertNil(error, @"Received error: %@", [error localizedDescription]);
      
      WPSImageDownloaderCompletionBlock interCompletion = ^(UIImage *image, NSURL *URL, NSError *error) {
         XCTAssertNotNil(image, @"Received nil image.");
         XCTAssertNil(error, @"Received error: %@", [error localizedDescription]);
         done = YES;
      };

      WPSImageDownloader *downloader = [[WPSImageDownloader alloc] init];
      [downloader setCache:cache];
      [downloader downloadImageAtURL:URL completion:interCompletion];
   };
   
   WPSImageDownloader *downloader = [[WPSImageDownloader alloc] init];
   [downloader setCache:cache];
   [downloader downloadImageAtURL:URL completion:completion];
   
   // Wait until the request finishes.
   while (!done) {
      // This executes another run loop.
      [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
      // Sleep 1/100th sec
      usleep(10000);
   }
}

@end
