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
   XCTAssertNotNil(queryDict, @"Unassigned query directory");
   XCTAssertTrue([queryDict count] == 2, @"Unexpected count.");
}

- (void)testIsEqualToURL
{
   NSURL *url1 = [NSURL URLWithString:@"http://www.thecave.com"];
   NSURL *url2 = [NSURL URLWithString:@"http://www.thecave.com/"];
   XCTAssertTrue([url1 wps_isEqualToURL:url2], @"Expected URLs to be equal.");
   
   url1 = [NSURL URLWithString:@"http://www.thecave.com/a/b/c"];
   url2 = [NSURL URLWithString:@"http://www.thecave.com/a/b/c/"];
   XCTAssertTrue([url1 wps_isEqualToURL:url2], @"Expected URLs to be equal.");
   
   url1 = [NSURL URLWithString:@"http://www.thecave.com/a/b/"];
   url2 = [NSURL URLWithString:@"http://www.thecave.com/a/b/c/"];
   XCTAssertFalse([url1 wps_isEqualToURL:url2], @"Expected URLs to not be equal.");
}

- (void)testHTTPURLWithString
{
  NSURL *URL;
  URL = [NSURL wps_HTTPURLWithString:@"thecave.com" secure:NO];
  XCTAssertTrue([[URL scheme] isEqualToString:@"http"], @"Unexpected scheme.");
  XCTAssertTrue([[URL host] isEqualToString:@"thecave.com"], @"Unexpected host.");
  
  URL = [NSURL wps_HTTPURLWithString:@"thecave.com:80" secure:YES];
  XCTAssertTrue([[URL scheme] isEqualToString:@"https"], @"Unexpected scheme.");
  XCTAssertTrue([[URL host] isEqualToString:@"thecave.com"], @"Unexpected host.");
  XCTAssertEqual([[URL port] integerValue], 80, @"Unexpected port number.");

  URL = [NSURL wps_HTTPURLWithString:@"http://thecave.com:80" secure:NO];
  XCTAssertTrue([[URL scheme] isEqualToString:@"http"], @"Unexpected scheme.");
  XCTAssertTrue([[URL host] isEqualToString:@"thecave.com"], @"Unexpected host.");
  XCTAssertEqual([[URL port] integerValue], 80, @"Unexpected port number.");
}

@end
