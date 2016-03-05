//
//  NSError+WPSKit.swift
//  WPSKit
//
//  Created by Kirby Turner on 3/5/16.
//  Copyright © 2016 White Peak Software, Inc. All rights reserved.
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