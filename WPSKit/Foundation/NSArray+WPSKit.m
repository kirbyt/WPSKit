//
//  NSArray+WPSKit.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 3/5/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import "NSArray+WPSKit.h"

@implementation NSArray (WPSKit)

- (id)wps_firstObject
{
   if ([self count] > 0) {
      return [self objectAtIndex:0];
   } else {
      return nil;
   }
}

@end
