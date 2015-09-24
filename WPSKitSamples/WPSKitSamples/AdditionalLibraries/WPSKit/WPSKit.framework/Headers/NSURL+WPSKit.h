//
// WPSKit
// NSURL+WPSKit.h
//
// Created by Kirby Turner.
// Copyright 2013 White Peak Software. All rights reserved.
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

/**
 This category adds methods to the Foundation's `NSURL` class. 
 */
@interface NSURL (WPSKit)

/**
 Returns a dictionary containing the query string parameters of the URL.
 
 @return An `NSDictionary` containing the query string parameters.
 */
- (NSDictionary *)wps_queryDictionary;

/**
 Returns a dictionary containing the query string parameters of the provided string.
 
 @return An `NSDictionary` containing the query string parameters.
 */
+ (NSDictionary *)wps_queryDictionaryWithString:(NSString *)queryString;

/**
 Compares the scheme, host, port, and path to determine if the URLs are equal. Query string parameters are ignored.
 
 @param URL A URL to compare to the receiver.
 
 @return `YES` if the URLs match, otherwise `NO`.
 */
- (BOOL)wps_isEqualToURL:(NSURL *)URL;

/**
 Creates and returns an NSURL object initialized with a provided URL string. This method ensures the scheme is HTTP or HTTPS when no scheme is provided in the URL string.
 
 This class method is ideal for cleaning up a user-entered web address.
 
 @param URLString The URL string with which to initialize the NSURL object.
 @param secure Set to `YES` to use HTTPS, `NO` for HTTP.
 
 @return An NSURL object initialized with URLString. If the URL string was malformed or nil, returns nil.
 */
+ (NSURL *)wps_HTTPURLWithString:(NSString *)URLString secure:(BOOL)secure;

@end
