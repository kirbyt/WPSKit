//
// String+Extensions.swift
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

extension String {

  // -------------------------------------------------------------------
  // MARK: - User Domain
  // -------------------------------------------------------------------
  
  /**
   Returns a string to the user's directory.
  
   This will create the directory if it does not exists.
  
   - parameter searchDirectory:   The search path directory. The supported values are described in `NSSearchPathDirectory`.
   - parameter pathComponent:     The path component to add to the URL, in its original form (not URL encoded).
  
   - returns The path with pathComponent appended if provided.
  */
  public static func userDomainPath(directory: NSSearchPathDirectory, pathComponent: String?) throws -> String? {
    if let url = self.userDomainURL(directory, pathComponent: pathComponent) {
      if let path = url.path {
        try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        
        return path
      }
    }

    return nil
  }
  
  /**
   Returns the URL to the user directory.
   
   This will **not** create the directory.

   - parameter searchDirectory:   The search path directory. The supported values are described in `NSSearchPathDirectory`.
   - parameter pathComponent:     The path component to add to the URL, in its original form (not URL encoded).
   
   - returns A new URL with pathComponent appended if provided.
   */
  public static func userDomainURL(directory: NSSearchPathDirectory, pathComponent: String?) -> NSURL? {
    let fm = NSFileManager.defaultManager()
    if var url = fm.URLsForDirectory(directory, inDomains: .UserDomainMask).last {
      if let pathComponent = pathComponent {
        url = url.URLByAppendingPathComponent(pathComponent)
      }
      return url
    }
    
    return nil
  }

  // -------------------------------------------------------------------
  // MARK: - Document Directory
  // -------------------------------------------------------------------
  
  /**
   Returns the path to the user's document directory.
  
   - returns A String containing the path.
   */
  public static func documentDirectory() -> String? {
    return try! self.documentDirectory(nil)
  }

  /**
   Returns the path to the user's document directory with `pathComponent` appended.
   
   - parameter pathComponent: The path component to add to the path, in its original form (not URL encoded).

   - returns A String containing the path with `pathComponent` appended.
   */
  public static func documentDirectory(pathComponent: String?) throws -> String? {
    return try self.userDomainPath(.DocumentDirectory, pathComponent: pathComponent)
  }
  
  /**
   Returns the URL to the user's document directory.
   
   - returns A URL containing the path.
   */
  public static func documentDirectoryURL() -> NSURL? {
    if let path = self.documentDirectory() {
      return NSURL(string: path)
    }
    return nil
  }
  
  /**
   Returns the URL to the user's document directory with `pathComponent` appended.
   
   - parameter pathComponent: The path component to add to the path, in its original form (not URL encoded).
   
   - returns A URL containing the path with `pathComponent` appended.
   */
  public static func documentDirectoryURL(pathComponent: String?) throws -> NSURL? {
    if let path = try self.documentDirectory(pathComponent) {
      return NSURL(string: path)
    }
    return nil
  }
  
  // -------------------------------------------------------------------
  // MARK: - Cache Directory
  // -------------------------------------------------------------------

  /**
  Returns the path to the user's cache directory.
  
  - returns A String containing the path.
  */
  public static func cacheDirectory() -> String? {
    return try! self.cacheDirectory(nil)
  }
  
  /**
   Returns the path to the user's cache directory with `pathComponent` appended.
   
   - parameter pathComponent: The path component to add to the path, in its original form (not URL encoded).
   
   - returns A String containing the path with `pathComponent` appended.
   */
  public static func cacheDirectory(pathComponent: String?) throws -> String? {
    return try self.userDomainPath(.CachesDirectory, pathComponent: pathComponent)
  }
  
  /**
   Returns the URL to the user's cache directory.
   
   - returns A URL containing the path.
   */
  public static func cacheDirectoryURL() -> NSURL? {
    if let path = self.cacheDirectory() {
      return NSURL(string: path)
    }
    return nil
  }
  
  /**
   Returns the URL to the user's cache directory with `pathComponent` appended.
   
   - parameter pathComponent: The path component to add to the path, in its original form (not URL encoded).
   
   - returns A URL containing the path with `pathComponent` appended.
   */
  public static func cacheDirectoryURL(pathComponent: String?) throws -> NSURL? {
    if let path = try self.cacheDirectory(pathComponent) {
      return NSURL(string: path)
    }
    return nil
  }

  // -------------------------------------------------------------------
  // MARK: - Temporary Directory
  // -------------------------------------------------------------------
  
  /**
  Returns the path to the user's temporary directory.
  
  - returns A String containing the path.
  */
  public static func temporaryDirectory() -> String? {
    return NSTemporaryDirectory()
  }
  
  /**
   Returns the path to the user's temporary directory with `pathComponent` appended.
   
   - parameter pathComponent: The path component to add to the path, in its original form (not URL encoded).
   
   - returns A String containing the path with `pathComponent` appended.
   */
  public static func temporaryDirectory(pathComponent: String?) throws -> String? {
    if let tmpDirectory = self.temporaryDirectory() {
      if var url = NSURL(string: tmpDirectory) {
        if let pathComponent = pathComponent {
          url = url.URLByAppendingPathComponent(pathComponent)
        }
        if let path = url.path {
          // Create the directory.
          try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
          return path
        }
      }
    }
    
    return nil
  }
  
  /**
   Returns the URL to the user's temporary directory.
   
   - returns A URL containing the path.
   */
  public static func temporaryDirectoryURL() -> NSURL? {
    if let path = self.temporaryDirectory() {
      return NSURL(string: path)
    }
    return nil
  }
  
  /**
   Returns the URL to the user's temporary directory with `pathComponent` appended.
   
   - parameter pathComponent: The path component to add to the path, in its original form (not URL encoded).
   
   - returns A URL containing the path with `pathComponent` appended.
   */
  public static func temporaryDirectoryURL(pathComponent: String?) throws -> NSURL? {
    if let path = try self.temporaryDirectory(pathComponent) {
      return NSURL(string: path)
    }
    return nil
  }

}

// -------------------------------------------------------------------
// MARK: - App Name and Version Extensions
// -------------------------------------------------------------------

extension String {

  public static func appName() -> String? {
    if let info = NSBundle.mainBundle().infoDictionary {
      if let appName = info["CFBundleDisplayName"] as? String {
        return appName
      }
    }
    
    return nil
  }
  
  public static func appVersion() -> String? {
    if let info = NSBundle.mainBundle().infoDictionary {
      if let version = info["CFBundleShortVersionString"] as? String {
        if let build = info["CFBundleVersion"] as? String {
          return "Version \(version) (build \(build))"
        }
      }
    }

    return nil
  }
  
  public static func appVersionShort() -> String?  {
    if let info = NSBundle.mainBundle().infoDictionary {
      if let version = info["CFBundleShortVersionString"] as? String {
        if let build = info["CFBundleVersion"] as? String {
          return "\(version).\(build))"
        }
      }
    }
    
    return nil
  }
}
