//
//  NSNullTests.m
//  WPSKitTests
//
//  Created by Kirby Turner on 1/3/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSNull+WPSKit.h"

@interface NSNullTests : SenTestCase

@end

@implementation NSNullTests

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

- (void)testNullIfNil
{
  NSString *s = nil;
  id result = wps_nullIfNil(s);
  STAssertTrue([NSNull null] == result, @"Didn't get an NSNull instance.");
  
  result = wps_nullIfNil(@"sam");
  STAssertTrue([result isKindOfClass:[NSString class]], @"Unexpected type.");
}

@end
