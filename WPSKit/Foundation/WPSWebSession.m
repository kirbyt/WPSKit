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
  }
  return self;
}


#pragma mark - GET Actions

- (void)getWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionCompletionBlock)completion
{
  WPSWebSessionCompletionBlock dispatchCompletion;
  dispatchCompletion = ^(NSURL *responseURL, NSData *responseData, BOOL didHitCache, NSString *cacheKey, NSError *error) {
    if (completion) {
      completion(URL, responseData, didHitCache, cacheKey, error);
    }
  };
  
  NSString *cacheKey = [self cacheKeyForURL:URL parameters:parameters];
  NSData *cachedData = [[self cache] dataForKey:cacheKey];
  if (cachedData) {
    dispatchCompletion(URL, cachedData, YES, cacheKey, nil);
    return;
  }
  
//  [self setCompletion:completion];
//  [self setNumberOfAttempts:0];

  __weak __typeof__(self) weakSelf = self;
  NSMutableURLRequest *request = [self getRequestWithURL:URL parameters:parameters];
  NSURLSession *session = [self session];
  NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (data) {
      __typeof__(self) strongSelf = weakSelf;
      if (strongSelf == nil) 
    }
    dispatchCompletion([response URL], data, NO, nil, error);
  }];
  [task resume];
}

- (void)getJSONWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebSessionJSONCompletionBlock)completion
{
  
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
