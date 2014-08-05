//
// WPSWebSession.m
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

#import "WPSWebSession.h"
#import "WPSCache.h"

@interface WPSWebSession () <NSURLSessionDelegate>
@property (nonatomic, strong) NSURLSession *session;

// We queue each non-cached request in case we receive the same
// request multiple times while processing the original request.
// This prevents making unnecessary calls on the wire. We also use
// this queue to track the number of request attempts.
@property (nonatomic, strong) NSMutableDictionary *requestQueue;
@end

@implementation WPSWebSession

#pragma mark - Init Methods

- (instancetype)init
{
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  return [self initWithConfiguration:configuration];
}

- (instancetype)initWithConfiguration:(NSURLSessionConfiguration *)configuration
{
  NSParameterAssert(configuration);
  
  self = [super init];
  if (self) {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [self setSession:session];
    
    [self setRetryCount:5];
    [self setCacheAge:300];   // 5 minutes
    [self setRequestQueue:[NSMutableDictionary dictionary]];
  }
  return self;
}

#pragma mark - GET Actions

- (void)getWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionCompletionBlock)completion
{
  NSString *cacheKey = [self cacheKeyForURL:URL parameters:parameters];
  WPSCache *cache = [self cache];
  NSData *cachedData = [cache dataForKey:cacheKey];
  if (cachedData) {
    if (completion) {
      completion(cachedData, nil, nil);
    }
    return;
  }
  
  BOOL isFirstRequest = ![self isRequestItemInQueue:cacheKey];
  [self addToRequestQueue:cacheKey completion:completion];
  // Do not resubmit the request if one has already been submitted.
  if (isFirstRequest == NO) {
    return;
  }

  __weak __typeof__(self) weakSelf = self;

  void (^dispatchCompletion)(NSString *requestQueueKey, NSData *data, NSURLResponse *response, NSError *error);
  dispatchCompletion = ^(NSString *requestQueueKey, NSData *data, NSURLResponse *response, NSError *error) {
    __typeof__(self) strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf dispatchRequestQueueItemWithKey:requestQueueKey data:data response:response error:error];
    }
  };

  NSMutableURLRequest *request = [self getRequestWithURL:URL parameters:parameters];
  NSURLSession *session = [self session];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;
    if (data) {
      __typeof__(self) strongSelf = weakSelf;
      if (strongSelf) {
        // Did we receive an HTTP error?
        NSInteger statusCode = 0;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
          statusCode = [(NSHTTPURLResponse *)response statusCode];
        }

        // Nope. Save the data to the local cache if available.
        if (statusCode >= 200 && statusCode < 300) {
          if (cache) {
            [cache cacheData:data forKey:cacheKey cacheLocation:WPSCacheLocationFileSystem cacheAge:[strongSelf cacheAge]];
          }
        } else {
          // Yep. Prepare to report the HTTP error back to the caller.
          errorToReport = WPSHTTPError([response URL], statusCode, data);
        }
      }
    }
    dispatchCompletion(cacheKey, data, response, errorToReport);
  }];
  [task resume];
}

- (void)getJSONWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionJSONCompletionBlock)completion
{
  WPSWebSessionJSONCompletionBlock dispatchCompletion;
  dispatchCompletion = ^(id jsonData, NSURLResponse *response, NSError *error) {
    if (completion) {
      completion(jsonData, response, error);
    }
  };
  
  [self getWithURL:URL parameters:parameters completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;
    id jsonData = nil;
    if (data) {
      errorToReport = nil;
      jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&errorToReport];
    }
    
    dispatchCompletion(jsonData, response, errorToReport);
  }];
}

- (NSMutableURLRequest *)getRequestWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters
{
  NSString *path = [self encodedPathWithURL:URL parameters:parameters];
  NSURL *getURL = [NSURL URLWithString:path];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:getURL];
  [request setHTTPMethod: @"GET"];
  if ([self additionalHTTPHeaderFields]) {
    [[self additionalHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
      [request setValue:value forHTTPHeaderField:key];
    }];
  }
  
  return request;
}

#pragma mark - POST Actions

- (void)post:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionCompletionBlock)completion
{
  NSData *postData = [self postDataWithParameters:parameters];
  [self post:URL data:postData contentType:@"application/x-www-form-urlencoded" completion:completion];
}

- (void)post:(NSURL *)URL jsonData:(id)jsonData completion:(WPSWebSessionJSONCompletionBlock)completion
{
  NSError *error = nil;
  NSData *data = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
  if (data) {
    [self post:URL data:data contentType:@"application/json" completion:completion];
  } else {
    if (completion) {
      completion(nil, nil, error);
    }
  }
}

- (void)post:(NSURL *)URL data:(NSData *)data contentType:(NSString *)contentType completion:(WPSWebSessionCompletionBlock)completion
{
  [self post:URL data:data contentType:contentType HTTPmethod:@"POST" completion:completion];
}

- (void)post:(NSURL *)URL data:(NSData *)data contentType:(NSString *)contentType HTTPmethod:(NSString *)HTTPMethod completion:(WPSWebSessionCompletionBlock)completion
{
  WPSWebSessionCompletionBlock dispatchCompletion;
  dispatchCompletion = ^(NSData *responseData, NSURLResponse *response, NSError *error) {
    if (completion) {
      completion(responseData, response, error);
    }
  };
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
  [request setHTTPMethod:HTTPMethod];

  if ([self additionalHTTPHeaderFields]) {
    [[self additionalHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
      [request setValue:value forHTTPHeaderField:key];
    }];
  }
  
  if (contentType) {
    [request setValue:contentType forHTTPHeaderField:@"content-type"];
  }
  
  NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[data length]];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setHTTPBody:data];

  __weak __typeof__(self) weakSelf = self;
  
  void (^taskCompletion)(NSData *responseData, NSURLResponse *response, NSError *error);
  taskCompletion = ^(NSData *responseData, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;
    if (responseData) {
      __typeof__(self) strongSelf = weakSelf;
      if (strongSelf) {
        // Did we receive an HTTP error?
        NSInteger statusCode = 0;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
          statusCode = [(NSHTTPURLResponse *)response statusCode];
        }
        
        if (statusCode < 200 || statusCode >= 300) {
          // Yep. Prepare to report the HTTP error back to the caller.
          errorToReport = WPSHTTPError([response URL], statusCode, data);
        }
      }
    }
    dispatchCompletion(responseData, response, errorToReport);
  };
  
  NSURLSession *session = [self session];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:taskCompletion];
  [task resume];
}

- (NSData *)postDataWithParameters:(NSDictionary *)parameters
{
  NSStringEncoding stringEncoding = NSUTF8StringEncoding;
  NSString *string = [self encodeQueryStringWithParameters:parameters encoding:stringEncoding];
  NSData *data = [string dataUsingEncoding:stringEncoding allowLossyConversion:YES];
  return data;
}

#pragma mark - Downloads

- (void)downloadFileAtURL:(NSURL *)URL completion:(WPSWebSessionDownloadCompletionBlock)completion
{
  [self downloadFileAtURL:URL parameters:nil completion:completion];
}

- (void)downloadFileAtURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionDownloadCompletionBlock)completion
{
  NSString *cacheKey = [self cacheKeyForURL:URL parameters:parameters];
  WPSCache *cache = [self cache];
  NSURL *cachedFileLocation = [cache fileURLForKey:cacheKey];
  if (cachedFileLocation) {
    if (completion) {
      completion(cachedFileLocation, nil, nil);
    }
    return;
  }
  
  BOOL isFirstRequest = ![self isRequestItemInQueue:cacheKey];
  [self addToDownloadRequestQueue:cacheKey completion:completion];
  // Do not resubmit the request if one has already been submitted.
  if (isFirstRequest == NO) {
    return;
  }
  
  __weak __typeof__(self) weakSelf = self;
  
  void (^dispatchCompletion)(NSString *requestQueueKey, NSURL *location, NSURLResponse *response, NSError *error);
  dispatchCompletion = ^(NSString *requestQueueKey, NSURL *location, NSURLResponse *response, NSError *error) {
    __typeof__(self) strongSelf = weakSelf;
    if (strongSelf) {
      [strongSelf dispatchDownloadRequestQueueItemWithKey:requestQueueKey location:location response:response error:error];
    }
  };
  
  void (^taskCompletion)(NSURL *location, NSURLResponse *response, NSError *error);
  taskCompletion = ^(NSURL *location, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;
    if (location) {
      __typeof__(self) strongSelf = weakSelf;
      if (strongSelf) {
        // Did we receive an HTTP error?
        NSInteger statusCode = 0;
        if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
          statusCode = [(NSHTTPURLResponse *)response statusCode];
        }
        
        // Nope. Save the data to the local cache if available.
        if (statusCode >= 200 && statusCode < 300) {
          if (cache) {
            [cache cacheFileAt:location forKey:cacheKey cacheAge:[strongSelf cacheAge]];
          }
        } else {
          // Yep. Prepare to report the HTTP error back to the caller.
          errorToReport = WPSHTTPError([response URL], statusCode, nil);
        }
      }
    }
    dispatchCompletion(cacheKey, location, response, errorToReport);
  };
  
  NSMutableURLRequest *request = [self getRequestWithURL:URL parameters:parameters];
  NSURLSession *session = [self session];
  NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:taskCompletion];
  [task resume];
}

#pragma mark - Images

- (void)imageAtURL:(NSURL *)URL completion:(WPSWebSessionImageCompletionBlock)completion
{
  [self imageAtURL:URL parameters:nil completion:completion];
}

- (void)imageAtURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionImageCompletionBlock)completion
{
  if (completion == nil) {
    // Without a completion block, we have no way to return the image.
    // So why waste the effort.
    return;
  }
  
  [self downloadFileAtURL:URL parameters:parameters completion:^(NSURL *location, NSURLResponse *response, NSError *error) {
    UIImage *image = nil;
    if ([location isFileURL]) {
      image = [UIImage imageWithContentsOfFile:[location path]];
    }
    completion(image, response, error);
  }];
}

#pragma mark - Request Queue

- (BOOL)isRequestItemInQueue:(NSString *)key
{
  BOOL inQueue = NO;
  NSMutableDictionary *requestQueue = [self requestQueue];
  NSMutableDictionary *requestItem = requestQueue[key];
  if (requestItem) {
    inQueue = YES;
  }
  return inQueue;
}

- (void)addToRequestQueue:(NSString *)key completion:(WPSWebSessionCompletionBlock)completion
{
  NSMutableDictionary *requestQueue = [self requestQueue];
  NSMutableDictionary *requestItem = requestQueue[key];
  if (requestItem == nil) {
    requestItem = [NSMutableDictionary dictionary];
    requestItem[@"completionBlocks"] = [NSMutableArray array];
    requestItem[@"numberOfAttempts"] = @(0);
    requestQueue[key] = requestItem;
  }
  if (completion) {
    NSMutableArray *requestItemCompletionBlocks = requestItem[@"completionBlocks"];
    [requestItemCompletionBlocks addObject:completion];
  }
}

- (void)addToDownloadRequestQueue:(NSString *)key completion:(WPSWebSessionDownloadCompletionBlock)completion
{
  NSMutableDictionary *requestQueue = [self requestQueue];
  NSMutableDictionary *requestItem = requestQueue[key];
  if (requestItem == nil) {
    requestItem = [NSMutableDictionary dictionary];
    requestItem[@"completionBlocks"] = [NSMutableArray array];
    requestItem[@"numberOfAttempts"] = @(0);
    requestQueue[key] = requestItem;
  }
  if (completion) {
    NSMutableArray *requestItemCompletionBlocks = requestItem[@"completionBlocks"];
    [requestItemCompletionBlocks addObject:completion];
  }
}

- (void)dispatchRequestQueueItemWithKey:(NSString *)key data:(NSData *)data response:(NSURLResponse *)response error:(NSError *)error
{
  NSMutableDictionary *requestQueue = [self requestQueue];
  NSMutableDictionary *requestItem = requestQueue[key];
  if (requestItem) {
    // Remove the request item right away. We don't want it
    // changing on us should another request for the same
    // item come in again.
    [requestQueue removeObjectForKey:key];
    
    NSArray *completionBlocks = requestItem[@"completionBlocks"];
    [completionBlocks enumerateObjectsUsingBlock:^(WPSWebSessionCompletionBlock completionBlock, NSUInteger idx, BOOL *stop) {
      completionBlock(data, response, error);
    }];
  }
}

- (void)dispatchDownloadRequestQueueItemWithKey:(NSString *)key location:(NSURL *)location response:(NSURLResponse *)response error:(NSError *)error
{
  NSMutableDictionary *requestQueue = [self requestQueue];
  NSMutableDictionary *requestItem = requestQueue[key];
  if (requestItem) {
    // Remove the request item right away. We don't want it
    // changing on us should another request for the same
    // item come in again.
    [requestQueue removeObjectForKey:key];
    
    NSArray *completionBlocks = requestItem[@"completionBlocks"];
    [completionBlocks enumerateObjectsUsingBlock:^(WPSWebSessionDownloadCompletionBlock completionBlock, NSUInteger idx, BOOL *stop) {
      completionBlock(location, response, error);
    }];
  }
}

#pragma mark - Caching

- (NSString *)cacheKeyForURL:(NSURL *)URL parameters:(NSDictionary *)parameters
{
  NSString *path = [self encodedPathWithURL:URL parameters:parameters];
  return path;
}

#pragma mark - Encoders

- (NSString *)encodedPathWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters
{
  NSString *path = [URL absoluteString];
  NSString *queryString = [self encodeQueryStringWithParameters:parameters encoding:NSUTF8StringEncoding];
  // Add the queryString to the URL. Be sure to append either ? or & if
  // ? is not already present.
  if (queryString) {
    NSUInteger location = [path rangeOfString:@"?"].location;
    NSString *stringFormat = location == NSNotFound ? @"?%@" : @"&%@";
    path = [path stringByAppendingFormat:stringFormat, queryString];
  }
  return path;
}

static NSString * URLEncodedStringFromStringWithEncoding(NSString *string, NSStringEncoding encoding)
{
  static NSString * const kTMLegalCharactersToBeEscaped = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\|~ ";
  
  CFStringRef encodedStringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kTMLegalCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
  NSString *encodedString = (__bridge_transfer NSString *)encodedStringRef;
  // Note: Do not need to call CFRelease(encodedStringRef). This is done
  // for us by using __bridge_transfer.
  return [encodedString copy];
}

- (NSString *)encodeQueryStringWithParameters:(NSDictionary *)parameters encoding:(NSStringEncoding)encoding
{
  if (parameters == nil) return nil;
  
  NSMutableArray *mutableParameterComponents = [NSMutableArray array];
  for (id key in [parameters allKeys]) {
    id value = [parameters valueForKey:key];
    if ([value isKindOfClass:[NSArray class]] == NO) {
      NSString *component = [NSString stringWithFormat:@"%@=%@",
                             URLEncodedStringFromStringWithEncoding([key description], encoding),
                             URLEncodedStringFromStringWithEncoding([[parameters valueForKey:key] description], encoding)];
      [mutableParameterComponents addObject:component];
    } else {
      for (id item in value) {
        NSString *component = [NSString stringWithFormat:@"%@[]=%@",
                               URLEncodedStringFromStringWithEncoding([key description], encoding),
                               URLEncodedStringFromStringWithEncoding([item description], encoding)];
        [mutableParameterComponents addObject:component];
      }
    }
  }
  NSString *queryString = [mutableParameterComponents componentsJoinedByString:@"&"];
  return queryString;
}

@end
