//
//  UIColorTests.m
//  WPSKitTests
//
//  Created by Kirby Turner on 11/22/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIColor+WPSKit.h"

@interface UIColorTests : XCTestCase

@end

@implementation UIColorTests

- (void)setUp
{
  [super setUp];
  // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
  // Put teardown code here; it will be run once, after the last test case.
  [super tearDown];
}

- (void)testColorWithHex
{
  UIColor *color = [UIColor wps_colorWithHex:0x007aff];
  NSString *hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"007AFF"], @"Unexpected hex string value (%@)", hexString);
  
  color = [UIColor wps_colorWithHex:0xe3e3e3];
  hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"E3E3E3"], @"Unexpected hex string value (%@)", hexString);
  
  color = [UIColor wps_colorWithHex:0xAAAAAA];
  hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"AAAAAA"], @"Unexpected hex string value (%@)", hexString);
}

- (void)testColorWithHexString
{
  UIColor *color = [UIColor wps_colorWithHexString:@"#007AFF"];
  NSString *hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"007AFF"], @"Unexpected hex string value (%@)", hexString);

  color = [UIColor wps_colorWithHexString:@"e3e3e3"];
  hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"E3E3E3"], @"Unexpected hex string value (%@)", hexString);

  color = [UIColor whiteColor];
  hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"FFFFFF"], @"Unexpected hex string value (%@)", hexString);
  
  color = [UIColor yellowColor];
  hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"FFFF00"], @"Unexpected hex string value (%@)", hexString);

  color = [UIColor redColor];
  hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"FF0000"], @"Unexpected hex string value (%@)", hexString);

  color = [UIColor lightGrayColor];
  hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"AAAAAA"], @"Unexpected hex string value (%@)", hexString);

  color = [UIColor blackColor];
  hexString = [color wps_hexString];
  XCTAssertTrue([hexString isEqualToString:@"000000"], @"Unexpected hex string value (%@)", hexString);
}

@end
