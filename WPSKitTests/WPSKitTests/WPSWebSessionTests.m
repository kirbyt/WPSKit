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

#pragma mark - GET Tests

- (void)testGETRequest
{
  [self prepare];

  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com"];
  WPSWebSession *webSession = [self webSession];
  [webSession getWithURL:URL parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
    
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

- (void)testGETRequestQueue
{
  [self prepare];

  __block NSInteger count = 3;
  WPSWebSessionCompletionBlock completionBlock;
  completionBlock = ^(NSData *data, NSURL *responseURL, NSError *error) {
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

#pragma mark - JSON Tests

- (void)testJSONGet
{
  [self prepare];
  
  NSURL *URL = [NSURL URLWithString:@"http://whitepeaksoftware.net:3000/get"];
  WPSWebSession *webSession = [self webSession];
  [webSession getJSONWithURL:URL parameters:nil completion:^(id jsonData, NSURL *responseURL, NSError *error) {
    XCTAssertTrue([jsonData isKindOfClass:[NSArray class]]);
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

#pragma mark - POST Tests

- (void)testPOSTRequest
{
  [self prepare];

  NSURL *URL = [NSURL URLWithString:@"http://whitepeaksoftware.net:3000/post"];
  NSDictionary *parameters = @{@"name":@"Kirby", @"city":@"Stowe"};
  WPSWebSession *webSession = [self webSession];
  [webSession post:URL parameters:parameters completion:^(NSData *data, NSURL *responseURL, NSError *error) {
    // Verify that the data was posted.
    WPSWebSession *getWebSession = [self webSession];
    [getWebSession getJSONWithURL:[NSURL URLWithString:@"http://whitepeaksoftware.net:3000/get"] parameters:nil completion:^(id jsonData, NSURL *responseURL, NSError *error) {
      if ([jsonData isKindOfClass:[NSArray class]]) {
        NSDictionary *item = [jsonData firstObject];
        XCTAssertTrue([item[@"name"] isEqualToString:@"Kirby"]);
        XCTAssertTrue([item[@"city"] isEqualToString:@"Stowe"]);
      }
      
      WPSWebSession *resetWebSession = [self webSession];
      [resetWebSession post:[NSURL URLWithString:@"http://whitepeaksoftware.net:3000/resetdata"] parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
        [self notify:kXCTUnitWaitStatusSuccess];
      }];
    }];
  }];

  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

- (void)testPOSTRequestWithEmptyBody
{
  [self prepare];

  WPSWebSession *webSession = [self webSession];
  [webSession post:[NSURL URLWithString:@"http://whitepeaksoftware.net:3000/resetdata"] parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
    [self notify:kXCTUnitWaitStatusSuccess];
  }];

  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

#pragma mark - Download Tests

- (void)testFileDownload
{
  [self prepare];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/images/thecave-logo-2.png"];
  WPSWebSession *webSession = [self webSession];
  [webSession downloadFileAtURL:URL completion:^(NSURL *location, NSURL *responseURL, NSError *error) {
    XCTAssertTrue([location isFileURL]);
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

- (void)testFileDownloadQueue
{
  [self prepare];

  __block NSInteger count = 3;
  WPSWebSessionDownloadCompletionBlock completion;
  completion = ^(NSURL *location, NSURL *responseURL, NSError *error) {
    XCTAssertTrue([location isFileURL]);
    --count;
    
    if (count < 1) {
      [self notify:kXCTUnitWaitStatusSuccess];
    }
  };
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/images/thecave-logo-2.png"];
  WPSWebSession *webSession = [self webSession];
  [webSession downloadFileAtURL:URL completion:completion];
  [webSession downloadFileAtURL:URL completion:completion];
  [webSession downloadFileAtURL:URL completion:completion];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

#pragma mark - Image Tests

- (void)testImageDownload
{
  [self prepare];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/images/thecave-logo-2.png"];
  WPSWebSession *webSession = [self webSession];
  [webSession imageAtURL:URL completion:^(UIImage *image, NSURL *responseURL, NSError *error) {
    XCTAssertNotNil(image);
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

#pragma mark - HTTP Error Tests

- (void)testHTTPErrorWithGETRequest
{
  [self prepare];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/gimmea404"];
  WPSWebSession *webSession = [self webSession];
  [webSession getWithURL:URL parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
    if ([[error domain] isEqualToString:WPSHTTPErrorDomain]) {
      NSNumber *HTTPStatusCode = [error userInfo][@"HTTPStatusCode"];
      XCTAssertEqual([HTTPStatusCode integerValue], 404);
    }
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

- (void)testHTTPErrorWithPOSTRequest
{
  [self prepare];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/gimmea404"];
  WPSWebSession *webSession = [self webSession];
  [webSession post:URL parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
    if ([[error domain] isEqualToString:WPSHTTPErrorDomain]) {
      NSNumber *HTTPStatusCode = [error userInfo][@"HTTPStatusCode"];
      XCTAssertEqual([HTTPStatusCode integerValue], 404);
    }
    [self notify:kXCTUnitWaitStatusSuccess];
  }];
  
  [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:10.0f];
}

@end
