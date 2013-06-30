//
//  NSData+WPSKit.h
//  WPSKitTests
//
//  Created by Kirby Turner on 6/30/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (WPSKit)

+ (NSData *)wps_dataWithBase64String:(NSString *)base64String;

@end
