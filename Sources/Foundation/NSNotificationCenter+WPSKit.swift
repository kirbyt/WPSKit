//
// NSNotificationCenter+WPSKit.swift
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

extension NSNotificationCenter {

  /**
   Post a notification on the main thread.
   
   The notification is posted immediately if called from the main thread, otherwise the notification is dispatched to the main thread.
   
   - parameter name:    The name of the notification.
   - parameter notificationSender:  The object posting the notification.
   - parameter userInfo:            Information about the the notification. May be nil.
   */
  public func postOnMainThread(name: String, object: AnyObject?, userInfo: [String:AnyObject]?) {
    if NSThread.isMainThread() {
      postNotificationName(name, object: object, userInfo: userInfo)
    } else {
      dispatch_async(dispatch_get_main_queue()) { [unowned self] in
        self.postNotificationName(name, object: object, userInfo: userInfo)
      }
    }
  }
}
