//
//  Base64Tests.m
//  WPSKitTests
//
//  Created by Kirby Turner on 6/30/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import "Base64Tests.h"
#import "NSData+WPSKit.h"
#import "NSString+WPSKit.h"

@implementation Base64Tests

- (void)testBase64
{
   NSString *string = @"Howdy folks.";
   NSString *base64String = [NSString wps_base64StringWithString:string];
   NSData *decodedData = [NSData wps_dataWithBase64String:base64String];
   NSString *decodedString = [[NSString alloc] initWithBytes:[decodedData bytes] length:[decodedData length] encoding:NSUTF8StringEncoding];
   
   XCTAssertTrue([decodedString isEqualToString:string], @"decodedString '%@' is not equal to expected string '%@'.", decodedString, string);
}


@end
