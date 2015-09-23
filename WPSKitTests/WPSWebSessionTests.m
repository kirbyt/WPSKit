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
  [webSession getWithURL:URL parameters:nil completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    [webSessionExpectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testGETRequestQueue
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];

  __block NSInteger count = 3;
  WPSWebSessionCompletionBlock completionBlock;
  completionBlock = ^(NSData *data, NSURLResponse *response, NSError *error) {
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
  
  NSURL *URL = [NSURL URLWithString:@"http://jsonplaceholder.typicode.com/posts"];
  WPSWebSession *webSession = [self webSession];
  [webSession getJSONWithURL:URL parameters:nil completion:^(id jsonData, NSURLResponse *response, NSError *error) {
    XCTAssertTrue([jsonData isKindOfClass:[NSArray class]]);
    [webSessionExpectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - POST Tests

- (void)testPOSTRequest
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];

  NSURL *URL = [NSURL URLWithString:@"http://jsonplaceholder.typicode.com/posts"];
  NSDictionary *parameters = @{@"title":@"foo", @"body":@"bar", @"userId": @(1)};
  WPSWebSession *webSession = [self webSession];
  [webSession post:URL jsonData:parameters completion:^(id jsonData, NSURLResponse *response, NSError *error) {
    // Verify that the data was posted.
    XCTAssertTrue(jsonData[@"id"], @"101");
    XCTAssertTrue(jsonData[@"title"], @"foo");
    XCTAssertTrue(jsonData[@"body"], @"body");
    XCTAssertTrue(jsonData[@"userId"], @"1");
    [webSessionExpectation fulfill];
  }];

  [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)testPOSTRequestWithEmptyBody
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];

  WPSWebSession *webSession = [self webSession];
  [webSession post:[NSURL URLWithString:@"http://jsonplaceholder.typicode.com/posts"] parameters:nil completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    [webSessionExpectation fulfill];
  }];

  [self waitForExpectationsWithTimeout:10 handler:nil];
}

#pragma mark - Download Tests

- (void)testFileDownload
{
  XCTestExpectation *webSessionExpectation = [self expectationWithDescription:@"web session"];
  
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/images/thecave-logo-2.png"];
  WPSWebSession *webSession = [self webSession];
  [webSession downloadFileAtURL:URL completion:^(NSURL *location, NSURLResponse *response, NSError *error) {
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
  completion = ^(NSURL *location, NSURLResponse *response, NSError *error) {
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
  [webSession imageAtURL:URL completion:^(UIImage *image, NSURLResponse *response, NSError *error) {
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
  [webSession getWithURL:URL parameters:nil completion:^(NSData *data, NSURLResponse *response, NSError *error) {
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
  
  // Github Pages returns 405 for invalid POST requests.
  NSURL *URL = [NSURL URLWithString:@"http://www.thecave.com/gimmea405"];
  WPSWebSession *webSession = [self webSession];
  [webSession post:URL parameters:nil completion:^(NSData *data, NSURLResponse *response, NSError *error) {
    if ([[error domain] isEqualToString:WPSHTTPErrorDomain]) {
      NSNumber *HTTPStatusCode = [error userInfo][@"HTTPStatusCode"];
      XCTAssertEqual([HTTPStatusCode integerValue], 405);
    }
    [webSessionExpectation fulfill];
  }];
  
  [self waitForExpectationsWithTimeout:10 handler:nil];
}

@end
