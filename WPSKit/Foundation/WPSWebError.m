//
// WPSWebError.m
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

#import "WPSWebError.h"

/**
 HTTPError function provided by 0xced.
 https://github.com/0xced/CLURLConnection
 */
NSString * const WPSHTTPErrorDomain = @"HTTPErrorDomain";
NSString * const WPSHTTPBody = @"HTTPBody";

FOUNDATION_EXTERN NSError* WPSHTTPError(NSURL *responseURL, NSInteger httpStatusCode, NSData *httpBody)
{
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];

  if (httpBody && [httpBody length] > 0) {
    NSString *httpBodyString = [[NSString alloc] initWithBytes:[httpBody bytes] length:[httpBody length] encoding:NSUTF8StringEncoding];
    userInfo[WPSHTTPBody] = httpBodyString;
    userInfo[NSLocalizedFailureReasonErrorKey] = httpBodyString;
  }
  
  if (responseURL) {
    userInfo[NSURLErrorKey] = responseURL;
    userInfo[@"NSErrorFailingURLKey"] = responseURL;
    userInfo[@"NSErrorFailingURLStringKey"] = [responseURL absoluteString];
  }
  userInfo[NSLocalizedDescriptionKey] = [NSHTTPURLResponse localizedStringForStatusCode:httpStatusCode];
  userInfo[@"HTTPStatusCode"] = @(httpStatusCode);
  
	return [NSError errorWithDomain:WPSHTTPErrorDomain code:httpStatusCode userInfo:[userInfo copy]];
}

