//
//  NSNull+WPSKit.h
//  WPSKitSamples
//
//  Created by Kirby Turner on 1/3/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Returns an NSNull instance if the current value is nil.
 */
static inline id wps_nullIfNil(id v)
{
   return v ? v : [NSNull null];
}

@interface NSNull (WPSKit)

@end
