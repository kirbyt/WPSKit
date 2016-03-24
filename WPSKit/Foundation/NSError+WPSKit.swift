//
// NSError+WPSKit.swift
//
// Created by Kirby Turner.
// Copyright 2016 White Peak Software. All rights reserved.
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

import Foundation

extension NSError {

  /**
   Constructs an `NSError` instance representing an HTTP error.
   
   - parameter responseURL:   The response URL.
   - parameter statusCode:    The HTTP status code.
   - parameter message:       The error message.
   - parameter data:          The contents of the response.
   
   - returns: An `NSError` containing the HTTP error.
   */
  public static func HTTPError(responseURL: NSURL!, statusCode: Int, message: String!, data: NSData!) -> NSError {
    var userInfo: [String: AnyObject] = [:]
    
    userInfo[NSLocalizedFailureReasonErrorKey] = message
    
    if data != nil && data.length > 0 {
      if let httpBody: String = NSString(bytes: data.bytes, length: data.length, encoding: NSUTF8StringEncoding) as? String {
        userInfo["HTTPBody"] = httpBody
        if message == nil {
          userInfo[NSLocalizedFailureReasonErrorKey] = httpBody
        }
      }
    }
    
    if responseURL != nil {
      userInfo[NSURLErrorKey] = responseURL
      userInfo["NSErrorFailingURLKey"] = responseURL
      userInfo["NSErrorFailingURLStringKey"] = responseURL.absoluteString
    }
    
    userInfo[NSLocalizedDescriptionKey] = NSHTTPURLResponse.localizedStringForStatusCode(statusCode)
    userInfo["HTTPStatusCode"] = statusCode;
    
    return NSError(domain: "HTTPErrorDomain", code: statusCode, userInfo: userInfo)
  }
  
}