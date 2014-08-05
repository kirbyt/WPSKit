//
// WPSWebSession.h
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

#import <Foundation/Foundation.h>
#import "WPSWebError.h"

@class WPSCache;
@protocol WPSCache;

/**
 The block that is executed after the GET request to the URL has completed.
 
 @param data The data returned by the server.
 @param response The metadata associated with the server response. This will be `nil` if the data is retrieved from the local cache.
 @param error The error that occured during the request. The error can indicate a failure to make or satisfy the request, or the error can be the HTTP error returned from the server.
 */
typedef void(^WPSWebSessionCompletionBlock)(NSData *data, NSURLResponse *response, NSError *error);

/**
 The block that is executed after the GET request to the URL has completed.

 @param jsonData A Foundation object from the JSON data in the server response data, or nil if an error occurs.
 @param response The metadata associated with the server response. This will be `nil` if the data is retrieved from the local cache.
 @param error The error that occured during the request. The error can indicate a failure to make or satisfy the request, or the error can be the HTTP error returned from the server.
*/
typedef void(^WPSWebSessionJSONCompletionBlock)(id jsonData, NSURLResponse *response, NSError *error);

@interface WPSWebSession : NSObject

/**
 A reference to a `WPSCache` object used as the local cache.
 
 The default is `nil`. Set this reference to `nil` to not use the local cache.
 */
@property (nonatomic, weak) id<WPSCache> cache;

/**
 The cache age for data stored in the local cache. 
 
 The default is 5 minutes. 
 
 This value is ignored when `cache` is `nil`.
 */
@property (nonatomic, assign) NSInteger cacheAge;

/**
 The maximum number of times the HTTP request is sent when an error occurs.
 
 Note that retries only happen when there is an error communicating with the server. Retry attempts do not happen with HTTP errors.
 
 The default is 5 times.
 */
@property (nonatomic, assign) NSInteger retryCount;   // Defaults to 5.

/**
 Additional header fields that are added to each HTTP request.
 */
@property (nonatomic, strong) NSDictionary *additionalHTTPHeaderFields;

/**
 */
- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration;

/**
 */
- (void)getWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionCompletionBlock)completion;

/**
 */
- (void)getJSONWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionJSONCompletionBlock)completion;

@end
