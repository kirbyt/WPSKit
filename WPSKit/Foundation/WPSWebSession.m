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
@property (nonatomic, strong) NSMutableDictionary *taskInfo; // Keeps additional information about download and upload tasks.

// We queue each non-cached request in case we receive the same
// request multiple times while processing the original request.
// This prevents making unnecessary calls on the wire. We also use
// this queue to track the number of request attempts.
@property (nonatomic, strong, readonly) NSMutableDictionary *requestQueue;
@end

@implementation WPSWebSession

#pragma mark - Request Queue

+ (NSMutableDictionary *)sharedRequestQueue
{
  // We use a shared request queue that spans across
  // multiple NSURLSessions.
  
  static NSMutableDictionary *sharedRequestQueue = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedRequestQueue = [NSMutableDictionary dictionary];
  });
  
  return sharedRequestQueue;
}

- (NSMutableDictionary *)requestQueue
{
  return [WPSWebSession sharedRequestQueue];
}

#pragma mark - Init Methods

- (void)dealloc
{
  NSURLSession *session = [self session];
  if (session) {
    [self setSession:nil];
    [session finishTasksAndInvalidate];
  }
}

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
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    [self setSession:session];
    
    [self setRetryCount:5];
    [self setCacheAge:300];   // 5 minutes
    [self setAdditionalHTTPHeaderFields:[NSDictionary dictionary]];
    [self setTaskInfo:[NSMutableDictionary dictionary]];
  }
  return self;
}

#pragma mark - GET Actions

- (void)getWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionCompletionBlock)completion
{
  [self getWithURL:URL parameters:parameters ignoreCache:NO completion:completion];
}

- (void)getWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters ignoreCache:(BOOL)ignoreCache completion:(WPSWebSessionCompletionBlock)completion
{
  NSString *cacheKey = [self cacheKeyForURL:URL parameters:parameters];
  NSInteger cacheAge = [self cacheAge];
  WPSCache *cache = nil;
  
  if (ignoreCache == NO) {
    cache = [self cache];
    
    NSData *cachedData = [cache dataForKey:cacheKey];
    if (cachedData) {
      if (completion) {
        completion(cachedData, nil, nil);
      }
      return;
    }
  }
  
  BOOL isFirstRequest = ![self isRequestItemInQueue:cacheKey];
  [self addToRequestQueue:cacheKey completion:completion];
  // Do not resubmit the request if one has already been submitted.
  if (isFirstRequest == NO) {
    return;
  }
  
  void (^dispatchCompletion)(NSString *requestQueueKey, NSData *data, NSURLResponse *response, NSError *error);
  dispatchCompletion = ^(NSString *requestQueueKey, NSData *data, NSURLResponse *response, NSError *error) {
    [self dispatchRequestQueueItemWithKey:requestQueueKey data:data response:response error:error];
  };
  
  NSMutableURLRequest *request = [self getRequestWithURL:URL parameters:parameters];
  NSURLSession *session = [self session];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;

    // Did we receive an HTTP error?
    NSInteger statusCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
      statusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    
    // Nope. Save the data to the local cache if available.
    if (statusCode >= 200 && statusCode < 300) {
      if (cache) {
        [cache cacheData:data forKey:cacheKey cacheLocation:WPSCacheLocationFileSystem cacheAge:cacheAge];
      }
    } else if (statusCode >= 300) {
      // Yep. Prepare to report the HTTP error back to the caller.
      errorToReport = WPSHTTPError([response URL], statusCode, data);
    }

    dispatchCompletion(cacheKey, data, response, errorToReport);
  }];
  [task resume];
}

- (void)getJSONWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionJSONCompletionBlock)completion
{
  [self getJSONWithURL:URL parameters:parameters ignoreCache:NO completion:completion];
}

- (void)getJSONWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters ignoreCache:(BOOL)ignoreCache completion:(WPSWebSessionJSONCompletionBlock)completion
{
  WPSWebSessionJSONCompletionBlock dispatchCompletion;
  dispatchCompletion = ^(id jsonData, NSURLResponse *response, NSError *error) {
    if (completion) {
      completion(jsonData, response, error);
    }
  };
  
  [self getWithURL:URL parameters:parameters ignoreCache:ignoreCache completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;
    id jsonData = nil;
    if (data && [data length] > 0 && error == nil) {
      NSError *jsonError = nil;
      jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
      if (jsonData == nil) {
        errorToReport = jsonError;
      }
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
  NSData *data = nil;
  if (jsonData) {
    NSError *error = nil;
    data = [NSJSONSerialization dataWithJSONObject:jsonData options:0 error:&error];
    if (data == nil) {
      if (completion) {
        completion(nil, nil, error);
      }
      return;
    }
  }
  
  [self post:URL data:data contentType:@"application/json" completion:^(NSData *responseData, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;
    id jsonResponseData = nil;
    if (responseData) {
      NSError *jsonError = nil;
      jsonResponseData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
      if (jsonResponseData == nil) {
        errorToReport = jsonError;
      }
    }
    if (completion) {
      completion(jsonResponseData, response, errorToReport);
    }
  }];
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
  
  void (^taskCompletion)(NSData *responseData, NSURLResponse *response, NSError *error);
  taskCompletion = ^(NSData *responseData, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;

    // Did we receive an HTTP error?
    NSInteger statusCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
      statusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    
    if (statusCode < 200 || statusCode >= 300) {
      // Yep. Prepare to report the HTTP error back to the caller.
      NSURL *urlToReport = [response URL];
      if (urlToReport == nil) {
        urlToReport = URL;
      }
      errorToReport = WPSHTTPError(urlToReport, statusCode, responseData);
    }
    
    dispatchCompletion(responseData, response, errorToReport);
  };
  
  NSURLSession *session = [self session];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:taskCompletion];
  [task resume];
}

- (NSData *)postDataWithParameters:(NSDictionary *)parameters
{
  NSString *string = [self encodeQueryStringWithParameters:parameters];
  NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
  return data;
}

- (void)post:(NSURL *)URL multipartFormData:(NSDictionary *)fields completion:(WPSWebSessionCompletionBlock)completion
{
  NSParameterAssert(URL);
  NSParameterAssert(fields);
  
  NSMutableArray *orderedFields = [NSMutableArray array];
  [fields enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    NSDictionary *item = @{key: obj};
    [orderedFields addObject:item];
  }];
  
  [self post:URL orderedMultipartFormData:orderedFields completion:completion];
}

- (void)post:(NSURL *)URL orderedMultipartFormData:(NSArray *)orderedFields completion:(WPSWebSessionCompletionBlock)completion
{
  NSParameterAssert(URL);
  NSParameterAssert(orderedFields);
  
  NSMutableArray *multipartFields = [NSMutableArray arrayWithCapacity:[orderedFields count]];
  [orderedFields enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
    id key = [[obj allKeys] firstObject];
    id value = obj[key];
    [multipartFields addObject:@[key, value]];
  }];
  
  void (^taskCompletion)(NSData *data, NSURLResponse *response, NSError *error);
  taskCompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;

    // Did we receive an HTTP error?
    NSInteger statusCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
      statusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    
    // Nope. Save the data to the local cache if available.
    if (statusCode >= 200 && statusCode < 300) {
      // We're good.
    } else if (statusCode >= 300) {
      // Yep. Prepare to report the HTTP error back to the caller.
      errorToReport = WPSHTTPError([response URL], statusCode, data);
    }

    if (completion) {
      completion(data, response, errorToReport);
    }
  };
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
  [request setHTTPMethod: @"POST"];
  if ([self additionalHTTPHeaderFields]) {
    [[self additionalHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
      [request setValue:value forHTTPHeaderField:key];
    }];
  }
  
  NSString *boundary = @"0xKhTmLbOuNdArY";
  NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
  [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
  [request setHTTPBody:[self multipartFormBodyWithBoundary:boundary fields:multipartFields]];
  
  NSURLSession *session = [self session];
  NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:taskCompletion];
  [task resume];
}

#pragma mark - Downloads

- (NSUInteger)downloadFileAtURL:(NSURL *)URL completion:(WPSWebSessionDownloadCompletionBlock)completion
{
  return [self downloadFileAtURL:URL parameters:nil completion:completion];
}

- (NSUInteger)downloadFileAtURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionDownloadCompletionBlock)completion
{
  NSUInteger taskIdentifier = NSIntegerMax;

  NSString *cacheKey = [self cacheKeyForURL:URL parameters:parameters];
  WPSCache *cache = [self cache];
  NSURL *cachedFileLocation = [cache fileURLForKey:cacheKey];
  if (cachedFileLocation) {
    if (completion) {
      completion(cachedFileLocation, nil, nil);
    }
    return taskIdentifier;
  }
  
  BOOL isFirstRequest = ![self isRequestItemInQueue:cacheKey];
  [self addToDownloadRequestQueue:cacheKey completion:completion];
  // Do not resubmit the request if one has already been submitted.
  if (isFirstRequest == NO) {
    taskIdentifier = [self taskIdentifierForDownloadRequestQueueKey:cacheKey];
    return taskIdentifier;
  }
  
  NSMutableURLRequest *request = [self getRequestWithURL:URL parameters:parameters];
  NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
  if (cachedResponse) {
    NSHTTPURLResponse *response = (NSHTTPURLResponse *)[cachedResponse response];
    NSString *lastModified = [response allHeaderFields][@"last-modified"];
    if (lastModified) {
      [request setValue:lastModified forHTTPHeaderField:@"If-Modified-Since"];
    }
  }
  NSURLSession *session = [self session];
  NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
  taskIdentifier = [task taskIdentifier];

  // Save additional information about this task.
  NSInteger cacheAge = [self cacheAge];
  NSMutableDictionary *taskInfo = [NSMutableDictionary dictionary];
  if (cache) {
    taskInfo[@"cache"] = cache;
  }
  taskInfo[@"cacheKey"] = cacheKey;
  taskInfo[@"cacheAge"] = @(cacheAge);
  [self taskInfo][@(taskIdentifier)] = taskInfo;

  [task resume];
  return taskIdentifier;
}

#pragma mark - Download Images

- (NSUInteger)imageAtURL:(NSURL *)URL completion:(WPSWebSessionImageCompletionBlock)completion
{
  return [self imageAtURL:URL parameters:nil completion:completion];
}

- (NSUInteger)imageAtURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionImageCompletionBlock)completion
{
  NSUInteger taskIdentifier = NSIntegerMax;
  if (completion == nil) {
    // Without a completion block, we have no way to return the image.
    // So why waste the effort.
    return taskIdentifier;
  }
  
  taskIdentifier = [self downloadFileAtURL:URL parameters:parameters completion:^(NSURL *location, NSURLResponse *response, NSError *error) {
    UIImage *image = nil;
    if ([location isFileURL]) {
      NSData *data = [NSData dataWithContentsOfURL:location options:NSDataReadingMappedIfSafe error:NULL];
      image = [UIImage imageWithData:data];
    }
    completion(image, response, error);
  }];
  return taskIdentifier;
}

#pragma mark - Uploads

- (void)uploadFile:(NSURL *)fileURL toURL:(NSURL *)URL completion:(WPSWebSessionCompletionBlock)completion
{
  [self uploadFile:fileURL toURL:URL multipartForm:NO completion:completion];
}

- (void)uploadFile:(NSURL *)fileURL toURL:(NSURL *)URL multipartForm:(BOOL)multipartForm completion:(WPSWebSessionCompletionBlock)completion
{
  NSParameterAssert(fileURL);
  NSParameterAssert(URL);
  
  void (^taskCompletion)(NSData *data, NSURLResponse *response, NSError *error);
  taskCompletion = ^(NSData *data, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;

    // Did we receive an HTTP error?
    NSInteger statusCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
      statusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    
    // Nope. Save the data to the local cache if available.
    if (statusCode >= 200 && statusCode < 300) {
      // We're good.
    } else if (statusCode >= 300) {
      // Yep. Prepare to report the HTTP error back to the caller.
      errorToReport = WPSHTTPError([response URL], statusCode, data);
    }

    if (completion) {
      completion(data, response, errorToReport);
    }
  };
  
  NSURLRequest *request = [self uploadRequestForFile:fileURL toURL:URL multipartForm:multipartForm];
  NSURLSession *session = [self session];
  NSURLSessionTask *task = nil;

  if (multipartForm) {
    task = [session dataTaskWithRequest:request completionHandler:taskCompletion];
    
  } else {
    task = [session uploadTaskWithRequest:request fromFile:fileURL completionHandler:taskCompletion];
  }
  [task resume];
}

- (void)uploadFile:(NSURL *)fileURL toURL:(NSURL *)URL
{
  NSParameterAssert(fileURL);
  NSParameterAssert(URL);
  
  NSURLRequest *request = [self uploadRequestForFile:fileURL toURL:URL multipartForm:NO];
  NSURLSession *session = [self session];
  NSURLSessionTask *task = nil;
  
  task = [session uploadTaskWithRequest:request fromFile:fileURL];
  [task resume];
}

- (NSURLRequest *)uploadRequestForFile:(NSURL *)fileURL toURL:(NSURL *)URL multipartForm:(BOOL)multipartForm
{
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
  [request setHTTPMethod: @"POST"];
  if ([self additionalHTTPHeaderFields]) {
    [[self additionalHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
      [request setValue:value forHTTPHeaderField:key];
    }];
  }
  
  if (multipartForm) {
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[self multipartFormBodyWithBoundary:boundary fields:@[@[@"file",fileURL]]]];
    
  } else {
    [request addValue:[fileURL lastPathComponent] forHTTPHeaderField:@"x-file-name"];
  }
  
  return request;
}

#pragma mark - Multipart Form Body Helper

- (NSData *)multipartFormBodyWithBoundary:(NSString *)boundary fields:(NSArray *)fields
{
  // Derived from code posted at: http://www.cocoadev.com/index.pl?HTTPFileUpload
  
  NSMutableData *body = [NSMutableData data];
  [fields enumerateObjectsUsingBlock:^(id itemArray, NSUInteger index, BOOL *stop) {
    if ([itemArray isKindOfClass:[NSArray class]] && [itemArray count] >= 2) {
      id key = itemArray[0];
      id value = itemArray[1];
      
      [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
      
      if ([value isKindOfClass:[NSData class]]) {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:value];
        
      } else if ([value isKindOfClass:[NSURL class]] && [value isFileURL]) {
        NSString *fileName = [[(NSURL *)value path] lastPathComponent];
        NSString *fileExt = [[fileName pathExtension] lowercaseString];
        NSString *fileContentType = @"application/octet-stream";
        if ([fileExt isEqualToString:@"jpg"] || [fileExt isEqualToString:@"jpeg"]) {
          fileContentType = @"image/jpeg";
        } else if ([fileExt isEqualToString:@"png"]) {
          fileContentType = @"image/png";
        }
        
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n",fileContentType] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithContentsOfFile:[(NSURL *)value path]]];
        
      } else {
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@", value] dataUsingEncoding:NSUTF8StringEncoding]];
      }
      
      [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
  }];
  [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  return [body copy];
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
    requestItem[@"taskIdentifier"] = @(NSIntegerMax);
    requestQueue[key] = requestItem;
  }
  if (completion) {
    NSMutableArray *requestItemCompletionBlocks = requestItem[@"completionBlocks"];
    [requestItemCompletionBlocks addObject:completion];
  }
}

- (NSUInteger)taskIdentifierForDownloadRequestQueueKey:(NSString *)key
{
  NSUInteger taskIdentifier = NSIntegerMax;
  NSMutableDictionary *requestQueue = [self requestQueue];
  NSMutableDictionary *requestItem = requestQueue[key];
  if (requestItem) {
    taskIdentifier = [requestItem[@"taskIdentifier"] unsignedIntegerValue];
  }
  return taskIdentifier;
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
  NSString *queryString = [self encodeQueryStringWithParameters:parameters];
  // Add the queryString to the URL. Be sure to append either ? or & if
  // ? is not already present.
  if (queryString) {
    NSUInteger location = [path rangeOfString:@"?"].location;
    NSString *stringFormat = location == NSNotFound ? @"?%@" : @"&%@";
    path = [path stringByAppendingFormat:stringFormat, queryString];
  }
  return path;
}

static NSString * URLEncodedStringFromStringWithEncoding(NSString *string)
{
  static NSString * const kTMLegalCharactersToBeEscaped = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\|~ ";
  NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:kTMLegalCharactersToBeEscaped] invertedSet];
  NSString *encodedString = [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
  return encodedString;
}

- (NSString *)encodeQueryStringWithParameters:(NSDictionary *)parameters 
{
  if (parameters == nil) return nil;
  
  NSMutableArray *mutableParameterComponents = [NSMutableArray array];
  for (id key in [parameters allKeys]) {
    id value = [parameters valueForKey:key];
    if ([value isKindOfClass:[NSArray class]] == NO) {
      NSString *component = [NSString stringWithFormat:@"%@=%@",
                             URLEncodedStringFromStringWithEncoding([key description]),
                             URLEncodedStringFromStringWithEncoding([[parameters valueForKey:key] description])];
      [mutableParameterComponents addObject:component];
    } else {
      for (id item in value) {
        NSString *component = [NSString stringWithFormat:@"%@[]=%@",
                               URLEncodedStringFromStringWithEncoding([key description]),
                               URLEncodedStringFromStringWithEncoding([item description])];
        [mutableParameterComponents addObject:component];
      }
    }
  }
  NSString *queryString = [mutableParameterComponents componentsJoinedByString:@"&"];
  return queryString;
}

#pragma mark - NSURLSessionDelegate Methods

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
  if ([[[challenge protectionSpace] authenticationMethod] isEqualToString:NSURLAuthenticationMethodServerTrust]) {
    // Is this a trusted server?
    NSString *host = [[challenge protectionSpace] host];
    
    __block BOOL isTrustedServer = NO;
    [[self trustedServers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      if ([host isEqualToString:[obj host]]) {
        isTrustedServer = YES;
        *stop = YES;
      }
    }];
    
    if (isTrustedServer) {
      completionHandler(NSURLSessionAuthChallengeUseCredential, [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
      
    } else {
      completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
    }
  }
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
  void(^completionHandler)() = [self backgroundTransferCompletionHandler];
  [self setBackgroundTransferCompletionHandler:nil]; // We don't need to keep this around.
  
  // Check if all download/upload tasks have been finished.
  [session getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
    if ([downloadTasks count] == 0 && [uploadTasks count] == 0) {
      if (completionHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
          completionHandler();
        });
      }
    }
  }];
}

#pragma mark - NSURLSessionTaskDelegate Methods

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error
{
  if (error == nil && [task error] == nil) {
    // The request was a success. Move along.
    return;
  }
  
  NSError *errorToReport = error;
  NSURLResponse *response = nil;
  NSString *cacheKey = nil;
  if ([task isKindOfClass:[NSURLSessionDownloadTask class]]) {
    NSDictionary *taskInfo = [self taskInfo][@([task taskIdentifier])];
    if (taskInfo)
    {
      cacheKey = taskInfo[@"cacheKey"];
    }
  }

  if ([task error]) {
    errorToReport = [task error];
    // Did we receive an HTTP error?
    response = [task response];
    NSInteger statusCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
      statusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    // Nope. Save the data to the local cache if available.
    if (statusCode > 0 && (statusCode >= 200 && statusCode < 300) == NO) {
      // Yep. Prepare to report the HTTP error back to the caller.
      errorToReport = WPSHTTPError([response URL], statusCode, nil);
    }
  }
  [self dispatchDownloadRequestQueueItemWithKey:cacheKey location:nil response:response error:errorToReport];
}

#pragma mark - NSURLSessionDownloadDelegate Methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
  WPSCache *cache = nil;
  NSString *cacheKey = nil;
  NSInteger cacheAge = [self cacheAge];

  NSDictionary *taskInfo = [self taskInfo][@([downloadTask taskIdentifier])];
  if (taskInfo) {
    cache = taskInfo[@"cache"];
    cacheKey = taskInfo[@"cacheKey"];
    cacheAge = [taskInfo[@"cacheAge"] integerValue];
  }
  
  NSURLResponse *response = [downloadTask response];
  NSError *error = [downloadTask error];
  NSError *errorToReport = error;
  
  // Did we receive an HTTP error?
  NSInteger statusCode = 0;
  if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
    statusCode = [(NSHTTPURLResponse *)response statusCode];
  }
  
  // Nope. Save the data to the local cache if available.
  if (statusCode >= 200 && statusCode < 300) {
    if (cache) {
      [cache cacheFileAt:location forKey:cacheKey cacheAge:cacheAge];
    }
  } else {
    // Yep. Prepare to report the HTTP error back to the caller.
    errorToReport = WPSHTTPError([response URL], statusCode, nil);
  }
  
  [self dispatchDownloadRequestQueueItemWithKey:cacheKey location:location response:response error:errorToReport];
}

#pragma mark - DELETE Action

- (void)delete:(NSURL *)URL completion:(WPSWebSessionCompletionBlock)completion
{
  WPSWebSessionCompletionBlock dispatchCompletion;
  dispatchCompletion = ^(NSData *responseData, NSURLResponse *response, NSError *error) {
    if (completion) {
      completion(responseData, response, error);
    }
  };
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
  [request setHTTPMethod:@"DELETE"];
  
  if ([self additionalHTTPHeaderFields]) {
    [[self additionalHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
      [request setValue:value forHTTPHeaderField:key];
    }];
  }
  
  void (^taskCompletion)(NSData *responseData, NSURLResponse *response, NSError *error);
  taskCompletion = ^(NSData *responseData, NSURLResponse *response, NSError *error) {
    NSError *errorToReport = error;

    // Did we receive an HTTP error?
    NSInteger statusCode = 0;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
      statusCode = [(NSHTTPURLResponse *)response statusCode];
    }
    
    if (statusCode < 200 || statusCode >= 300) {
      // Yep. Prepare to report the HTTP error back to the caller.
      NSURL *urlToReport = [response URL];
      if (urlToReport == nil) {
        urlToReport = URL;
      }
      errorToReport = WPSHTTPError(urlToReport, statusCode, responseData);
    }

    dispatchCompletion(responseData, response, errorToReport);
  };
  
  NSURLSession *session = [self session];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:taskCompletion];
  [task resume];
}

@end
