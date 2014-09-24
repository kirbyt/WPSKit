//
//  WPSWebSessionTests.m
//  WPSKitTests
//
//  Created by Kirby Turner on 7/28/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WPSWebSession.h"

@interface WPSWebSessionTests : XCTestCase
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
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];

  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com"];
  WPSWebSession *webSession = [self webSession];
  [webSession getWithURL:URL parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
    
    [webSessionExpectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testGETRequestQueue
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];

  __block NSInteger count = 3;
  WPSWebSessionCompletionBlock completionBlock;
  completionBlock = ^(NSData *data, NSURL *responseURL, NSError *error) {
    --count;
    if (count < 1) {
      [webSessionExpectation fulfill];
    }
  };
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com"];
  WPSWebSession *webSession = [self webSession];
  [webSession getWithURL:URL parameters:nil completion:completionBlock];
  [webSession getWithURL:URL parameters:nil completion:completionBlock];
  [webSession getWithURL:URL parameters:nil completion:completionBlock];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - JSON Tests

- (void)testJSONGet
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];
  
  NSURL *URL = [NSURL URLWithString:@"http://whitepeaksoftware.net:3000/get"];
  WPSWebSession *webSession = [self webSession];
  [webSession getJSONWithURL:URL parameters:nil completion:^(id jsonData, NSURL *responseURL, NSError *error) {
    XCTAssertTrue([jsonData isKindOfClass:[NSArray class]]);
    [webSessionExpectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - POST Tests

- (void)testPOSTRequest
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];

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
        [webSessionExpectation fulfill];
      }];
    }];
  }];

  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testPOSTRequestWithEmptyBody
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];

  WPSWebSession *webSession = [self webSession];
  [webSession post:[NSURL URLWithString:@"http://whitepeaksoftware.net:3000/resetdata"] parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
    [webSessionExpectation fulfill];
  }];

  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - multi-part/form-data POST Tests

- (void)testMultipartFormDataPOSTRequest
{
  // TODO: Implement /multipartpost endpoint.
//  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];
//  
//  NSURL *URL = [NSURL URLWithString:@"http://whitepeaksoftware.net:3000/multipartpost"];
//  NSDictionary *parameters = @{@"name":@"Kirby", @"city":@"Stowe"};
//  WPSWebSession *webSession = [self webSession];
//  [webSession post:URL multipartFormData:parameters completion:^(NSData *data, NSURL *responseURL, NSError *error) {
//    // Verify that the data was posted.
//    WPSWebSession *getWebSession = [self webSession];
//    [getWebSession getJSONWithURL:[NSURL URLWithString:@"http://whitepeaksoftware.net:3000/get"] parameters:nil completion:^(id jsonData, NSURL *responseURL, NSError *error) {
//      if ([jsonData isKindOfClass:[NSArray class]]) {
//        NSDictionary *item = [jsonData firstObject];
//        XCTAssertTrue([item[@"name"] isEqualToString:@"Kirby"]);
//        XCTAssertTrue([item[@"city"] isEqualToString:@"Stowe"]);
//      }
//      
//      WPSWebSession *resetWebSession = [self webSession];
//      [resetWebSession post:[NSURL URLWithString:@"http://whitepeaksoftware.net:3000/resetdata"] parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
//        [webSessionExpectation fulfill];
//      }];
//    }];
//  }];
//  
//  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - Download Tests

- (void)testFileDownload
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/images/thecave-logo-2.png"];
  WPSWebSession *webSession = [self webSession];
  [webSession downloadFileAtURL:URL completion:^(NSURL *location, NSURL *responseURL, NSError *error) {
    XCTAssertTrue([location isFileURL]);
    [webSessionExpectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testFileDownloadQueue
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];

  __block NSInteger count = 3;
  WPSWebSessionDownloadCompletionBlock completion;
  completion = ^(NSURL *location, NSURL *responseURL, NSError *error) {
    XCTAssertTrue([location isFileURL]);
    --count;
    
    if (count < 1) {
      [webSessionExpectation fulfill];
    }
  };
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/images/thecave-logo-2.png"];
  WPSWebSession *webSession = [self webSession];
  [webSession downloadFileAtURL:URL completion:completion];
  [webSession downloadFileAtURL:URL completion:completion];
  [webSession downloadFileAtURL:URL completion:completion];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - Image Tests

- (void)testImageDownload
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/images/thecave-logo-2.png"];
  WPSWebSession *webSession = [self webSession];
  [webSession imageAtURL:URL completion:^(UIImage *image, NSURL *responseURL, NSError *error) {
    XCTAssertNotNil(image);
    [webSessionExpectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - HTTP Error Tests

- (void)testHTTPErrorWithGETRequest
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/gimmea404"];
  WPSWebSession *webSession = [self webSession];
  [webSession getWithURL:URL parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
    if ([[error domain] isEqualToString:WPSHTTPErrorDomain]) {
      NSNumber *HTTPStatusCode = [error userInfo][@"HTTPStatusCode"];
      XCTAssertEqual([HTTPStatusCode integerValue], 404);
    }
    [webSessionExpectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testHTTPErrorWithPOSTRequest
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/gimmea404"];
  WPSWebSession *webSession = [self webSession];
  [webSession post:URL parameters:nil completion:^(NSData *data, NSURL *responseURL, NSError *error) {
    if ([[error domain] isEqualToString:WPSHTTPErrorDomain]) {
      NSNumber *HTTPStatusCode = [error userInfo][@"HTTPStatusCode"];
      XCTAssertEqual([HTTPStatusCode integerValue], 404);
    }
    [webSessionExpectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
