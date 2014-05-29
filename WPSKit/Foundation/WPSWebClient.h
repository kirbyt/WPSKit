//
// WPSWebClient.h
//
// Created by Kirby Turner.
// Copyright 2012 White Peak Software. All rights reserved.
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
#import "WPSCache.h"

typedef void(^WPSWebClientCompletionBlock)(NSURL *responseURL, NSData *responseData, BOOL didHitCache, NSString *cacheKey, NSError *error);  // (Response data, hit cache, error)
typedef BOOL(^WPSWebClientCanAuthenticate)(NSURLProtectionSpace *protectionSpace);
typedef void(^WPSWebClientDidReceiveAuthenticationChallenge)(NSURLAuthenticationChallenge *challenge);


@interface WPSWebClient : NSObject

@property (nonatomic, strong) id<WPSCache> cache;
@property (nonatomic, assign) NSInteger cacheAge;     // Defaults to 5 minutes.
@property (nonatomic, assign) NSInteger retryCount;   // Defaults to 5.
@property (nonatomic, strong) NSDictionary *additionalHTTPHeaderFields;
@property (nonatomic, strong) NSURLCredential *defaultCredential;
@property (nonatomic, copy) WPSWebClientCanAuthenticate canAuthenticateBlock;
@property (nonatomic, copy) WPSWebClientDidReceiveAuthenticationChallenge didReceiveAuthenticationChallengeBlock;

- (void)post:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebClientCompletionBlock)completion;
- (void)post:(NSURL *)URL contentType:(NSString *)contentType data:(NSData *)data completion:(WPSWebClientCompletionBlock)completion;

- (void)put:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebClientCompletionBlock)completion;
- (void)get:(NSURL *)URL parameters:(NSDictionary *)parameters completion:(WPSWebClientCompletionBlock)completion;

/**
 Returns a properly configured `NSURLRequest` object for an HTTP GET request.
 
 @param URL The URL that is called in the GET request.
 @param parameters The `NSDictionary` containing the parameters to include in the query string. The key is the parameter name, and the value is the parameter value. Pass `nil` if there are no query string parameters.
 */
- (NSMutableURLRequest *)getRequestWithURL:(NSURL *)URL parameters:(NSDictionary *)parameters;

@end
