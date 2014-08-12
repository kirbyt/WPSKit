//
// WPSKit
// NSManagedObject+WPSKit.m
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

#import "NSManagedObject+WPSKit.h"

@implementation NSManagedObject (WPSKit)

- (void)wps_safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues userInfo:(NSDictionary *)userInfo dateFormatter:(id)dateFormatter
{
  NSDictionary *attributes = [[self entity] attributesByName];
  for (NSString *attribute in attributes) {
    NSString *key = nil;
    if (userInfo) {
      // Look up the key for this attribute.
      key = userInfo[attribute];
      if (key == nil) {
        continue;
      }
    } else {
      key = attribute;
    }
    
    id value = keyedValues[key];
    // If the value is nil, then we do nothing.
    if (value == nil) {
      continue;
    }
    // However, if the value is null, then we clear it out
    // in the model object.
    if ([value isKindOfClass:[NSNull class]]) {
      [self setValue:nil forKey:attribute];
      continue;
    }
    
    NSAttributeType attributeType = [attributes[attribute] attributeType];
    if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
      value = [value stringValue];
    } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
      value = @([value integerValue]);
    } else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass:[NSString class]])) {
      value = @([value doubleValue]);
    } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]]) && (dateFormatter != nil)) {
      value = [dateFormatter dateFromString:value];
    }
    [self setValue:value forKey:attribute];
  }
}

@end
