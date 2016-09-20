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
   - parameter isDirectory:       If `true`, a trailing slash is appended after pathComponent. The default is `true`.
  
   - returns A `String` containing the path with pathComponent appended if provided.
  */
  public static func userDomainPath(_ directory: FileManager.SearchPathDirectory, pathComponent: String?, isDirectory: Bool = true) throws -> String? {
    let url = try URL.userDomainURL(directory, pathComponent: pathComponent, isDirectory: isDirectory)
    return url?.path
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

   This will create the directory if it does not exists.

   - parameter pathComponent: The path component to add to the path, in its original form (not URL encoded).
   - parameter isDirectory:   If `true`, a trailing slash is appended after pathComponent. The default is `true`.

   - returns A String containing the path with `pathComponent` appended.
   */
  public static func documentDirectory(_ pathComponent: String?, isDirectory: Bool = true) throws -> String? {
    return try self.userDomainPath(.documentDirectory, pathComponent: pathComponent, isDirectory: isDirectory)
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
  
   This will create the directory if it does not exists.
   
   - parameter pathComponent: The path component to add to the path, in its original form (not URL encoded).
   - parameter isDirectory:   If `true`, a trailing slash is appended after pathComponent. The default is `true`.
   
   - returns A String containing the path with `pathComponent` appended.
   */
  public static func cacheDirectory(_ pathComponent: String?, isDirectory: Bool = true) throws -> String? {
    return try self.userDomainPath(.cachesDirectory, pathComponent: pathComponent, isDirectory: isDirectory)
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
   
   This will create the directory if it does not exists.
   
   - parameter pathComponent: The path component to add to the path, in its original form (not URL encoded).
   - parameter isDirectory:   If `true`, a trailing slash is appended after pathComponent. The default is `true`.
   
   - returns A String containing the path with `pathComponent` appended.
   */
  public static func temporaryDirectory(_ pathComponent: String?, isDirectory: Bool = true) throws -> String? {
    if let tmpDirectory = self.temporaryDirectory() {
      if var url = URL(string: tmpDirectory) {

        if isDirectory {
          if let pathComponent = pathComponent {
            url = url.appendingPathComponent(pathComponent)
          }
        }
        
        // Create the directory.
        try FileManager.default.createDirectory(atPath: url.path, withIntermediateDirectories: true, attributes: nil)
        
        // Add the path component if it is not a directory.
        if isDirectory == false {
          if let pathComponent = pathComponent {
            url = url.appendingPathComponent(pathComponent)
          }
        }
        
        return url.path
      }
    }
    
    return nil
  }
  
  // -------------------------------------------------------------------
  // MARK: - App Name and Version Extensions
  // -------------------------------------------------------------------

  /**
    Returns the app name as defined in the info.plist.
  
    - returns A string containing the app name.
    */
  public static func appName() -> String? {
    if let info = Bundle.main.infoDictionary {
      if let appName = info["CFBundleDisplayName"] as? String {
        return appName
      }
    }
    
    return nil
  }
  
  /**
   Returns the app version and build number as defined in the info.plist.
   
   The version is represented as "Version 1.0 (1)".
   
   - returns A string containing the app version.
   */
  public static func appVersion() -> String? {
    if let info = Bundle.main.infoDictionary {
      if let version = info["CFBundleShortVersionString"] as? String {
        if let build = info["CFBundleVersion"] as? String {
          return "Version \(version) (build \(build))"
        }
      }
    }

    return nil
  }
  
  /**
   Returns the app version and build number as defined in the info.plist.

   The version is represented as "1.0.1".

   - returns A string containing the app version.
   */
  public static func appVersionShort() -> String?  {
    if let info = Bundle.main.infoDictionary {
      if let version = info["CFBundleShortVersionString"] as? String {
        if let build = info["CFBundleVersion"] as? String {
          return "\(version).\(build))"
        }
      }
    }
    
    return nil
  }
}
