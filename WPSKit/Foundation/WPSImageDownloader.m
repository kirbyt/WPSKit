/**
 **   WPSImageDownloader
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

#import "WPSImageDownloader.h"

@interface WPSImageDownloader ()
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, strong) NSMutableData *receivedData;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, copy) ImageDownloaderCompletionBlock completion;

- (NSString *)cacheKey;
@end

@implementation WPSImageDownloader

@synthesize cache = _cache;
@synthesize image = _image;
@synthesize URL = _URL;
@synthesize completion = _completion;
@synthesize receivedData = _receivedData;

- (void)downloadImageAtURL:(NSURL *)URL completion:(void(^)(UIImage *image, NSError*))completion
{
   if (URL) {
      [self setURL:URL];
      [self setCompletion:completion];
      
      if ([self cache]) {
         NSData *data = [[self cache] dataForKey:[self cacheKey]];
         if (data) {
            UIImage *image = [UIImage imageWithData:data];
            completion(image, nil);
            return;
         }
      }
      
      [self setReceivedData:[[NSMutableData alloc] init]];
      NSURLRequest *request = [NSURLRequest requestWithURL:URL];
      NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
      [connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
      [connection start];
   }
}

- (NSString *)cacheKey
{
   NSString *cacheKey = [[self URL] absoluteString];
   return cacheKey;
}

#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   [[self receivedData] setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
   [[self receivedData] appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
   [self setImage:[UIImage imageWithData:[self receivedData]]];
   if ([self cache]) {
      [[self cache] cacheData:[self receivedData] forKey:[self cacheKey] cacheLocation:WPSCacheLocationFileSystem];
   }
   [self setReceivedData:nil];
   
   ImageDownloaderCompletionBlock completion = [self completion];
   completion([self image], nil);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
   [self setReceivedData:nil];
   
   ImageDownloaderCompletionBlock completion = [self completion];
   completion(nil, error);
}

@end
