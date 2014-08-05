//
//  WPSWebSessionTests.m
//  WPSKitTests
//
//  Created by Kirby Turner on 7/28/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XCTAsyncTestCase.h"
#import "WPSWebSession.h"

@interface WPSWebSessionTests : XCTAsyncTestCase
@property (nonatomic, strong) WPSWebSession *webSession;
@end

@implementation WPSWebSessionTests

- (void)setUp
{
  [super setUp];

  NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
  WPSWebSession *webSession = [[WPSWebSession alloc] initWithConfiguration:sessionConfiguration];
  [self setWebSession:webSession];
}

- (void)tearDown
{
  [super tearDown];
}

- (void)testGETRequest
{
  [self prepare];

  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com"];
  WPSWebSession *webSession = [self webSession];
  [webSession getWithURL:URL parameters:nil completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

- (void)testGETRequestQueue
{
  [self prepare];

  __block NSInteger count = 3;
  WPSWebSessionCompletionBlock completionBlock;
  completionBlock = ^(NSData *data, NSURLResponse *response, NSError *error) {
    --count;
    if (count < 1) {
      [self notify:kXCTUnitWaitStatusSuccess];
    }
  };
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com"];
  WPSWebSession *webSession = [self webSession];
  [webSession getWithURL:URL parameters:nil completion:completionBlock];
  [webSession getWithURL:URL parameters:nil completion:completionBlock];
  [webSession getWithURL:URL parameters:nil completion:completionBlock];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

- (void)testHTTPError
{
  [self prepare];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/gimmea404"];
  WPSWebSession *webSession = [self webSession];
  [webSession getWithURL:URL parameters:nil completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    if ([[error domain] isEqualToString:WPSHTTPErrorDomain]) {
      NSNumber *HTTPStatusCode = [error userInfo][@"HTTPStatusCode"];
      XCTAssertEqual([HTTPStatusCode integerValue], 404);
    }
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

#pragma mark - JSON Tests

- (void)testJSONGet
{
  [self prepare];
  
  NSURL *URL = [NSURL URLWithString:@"http://whitepeaksoftware.net:3000/get"];
  WPSWebSession *webSession = [self webSession];
  [webSession getJSONWithURL:URL parameters:nil completion:^(id jsonData, NSURLResponse *response, NSError *error) {
    XCTAssertTrue([jsonData isKindOfClass:[NSArray class]]);
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

@end
