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

  NSURL *URL = [NSURL URLWithString:@"http://127.0.0.1:8080"];
  WPSWebSession *webSession = [self webSession];
  [webSession getWithURL:URL parameters:nil completion:^(NSURL *responseURL, NSData *responseData, BOOL didHitCache, NSString *cacheKey, NSError *error) {
    
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

@end
