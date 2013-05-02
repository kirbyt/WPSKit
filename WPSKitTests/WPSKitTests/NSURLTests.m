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

- (void)testIsEqualToURL
{
   NSURL *url1 = [NSURL URLWithString:@"http://www.thecave.com"];
   NSURL *url2 = [NSURL URLWithString:@"http://www.thecave.com/"];
   STAssertTrue([url1 wps_isEqualToURL:url2], @"Expected URLs to be equal.");
   
   url1 = [NSURL URLWithString:@"http://www.thecave.com/a/b/c"];
   url2 = [NSURL URLWithString:@"http://www.thecave.com/a/b/c/"];
   STAssertTrue([url1 wps_isEqualToURL:url2], @"Expected URLs to be equal.");
   
   url1 = [NSURL URLWithString:@"http://www.thecave.com/a/b/"];
   url2 = [NSURL URLWithString:@"http://www.thecave.com/a/b/c/"];
   STAssertFalse([url1 wps_isEqualToURL:url2], @"Expected URLs to not be equal.");
}
@end
