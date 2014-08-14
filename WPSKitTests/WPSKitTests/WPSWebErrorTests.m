//
//  WPSWebErrorTests.m
//  WPSKitTests
//
//  Created by Kirby Turner on 8/14/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WPSWebError.h"

@interface WPSWebErrorTests : XCTestCase

@end

@implementation WPSWebErrorTests

- (void)testWebError
{
  NSError *error = WPSHTTPError(nil, 404, nil);
  XCTAssertNotNil(error);
  XCTAssertEqual([[error userInfo][@"HTTPStatusCode"] integerValue], 404);
  
  error = WPSHTTPError([NSURL URLWithString:@"http://thecave.com"], 403, nil);
  XCTAssertNotNil(error);
  XCTAssertEqual([[error userInfo][@"HTTPStatusCode"] integerValue], 403);
  XCTAssertEqual([[error userInfo][NSURLErrorKey] absoluteString], @"http://thecave.com");

  NSString *bodyString = @"This is a test.";
  NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
  error = WPSHTTPError([NSURL URLWithString:@"http://thecave.com"], 200, bodyData);
  XCTAssertNotNil(error);
  XCTAssertEqual([[error userInfo][@"HTTPStatusCode"] integerValue], 200);
  XCTAssertEqual([[error userInfo][NSURLErrorKey] absoluteString], @"http://thecave.com");
  XCTAssertEqualObjects([error userInfo][WPSHTTPBody], bodyString);
}

@end
