//
//  NSURLTests.m
//  WPSKitTests
//
//  Created by Kirby Turner on 3/16/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import "NSURLTests.h"
#import "NSURL+WPSKit.h"

@implementation NSURLTests

- (void)testQueryDictionary
{
   NSURL *url = [NSURL URLWithString:@"http://www.thecave.com?a=1&b=2"];
   NSDictionary *queryDict = [url wps_queryDictionary];
   STAssertNotNil(queryDict, @"Unassigned query directory");
   STAssertTrue([queryDict count] == 2, @"Unexpected count.");
}

@end
