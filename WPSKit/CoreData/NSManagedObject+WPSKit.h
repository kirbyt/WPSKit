//
// WPSKit
// NSManagedObject+WPSKit.h
//
// Created by Kirby Turner.
// Copyright 2011 White Peak Software. All rights reserved.
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
#import <CoreData/CoreData.h>

/**
 This category adds methods to the Core Data framework’s `NSManagedObject` class. The methods in this category provide support commonly used tasks performed when working with instances of `NSManagedObject`.
 */
@interface NSManagedObject (WPSKit)

/**
 Provides a safe way to import JSON data into Core Data.
 
 This method is based on an article from Tom Harrington. The article available at: http://www.cimgf.com/2011/06/02/saving-json-to-core-data/
 
 @param keyedValues `NSDictionary` containing values that are imported into Core Data.
 @param userInfo Maps entity attributes to keys used to look up the keyed value. `nil` specifies no mapping.
 @param dateFormatter `NSDateFormatter` or `ISO8601DateFormatter` used to format date values. `nil` specifies no date formatter.
 */
- (void)wps_safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues userInfo:(NSDictionary *)userInfo dateFormatter:(id)dateFormatter;

@end
