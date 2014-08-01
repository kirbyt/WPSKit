xctest-additions
=============
This repository contains code made publicly available by iHeartRadio to extend and make testing using Apple's XCTest framework easier.
Feel free to use, copy and modify this code as you wish, maintaining and respecting original copyright notices if present.

XCTAsyncTestCase
---------------
XCTest-capable drop-in replacements for [GHUnit](https://github.com/gabriel/gh-unit/)'s class for writing asynchronous tests, `GHAsyncUnitTestCase`.
This class will let you test asynchronous behavior using regular XCTest targets so they can be ran easily from Xcode or Xcode Server.

Drag the files `XCTAsyncTestCase.h` and `XCTAsyncTestCase.m` into your project and add them to your iOS tests target. 

Example test case on blocks usage, `TestAsync.m`:
```
@interface TestAsync : XCTAsyncTestCase

@end

@implementation TestAsync
- (void)testBlockSample
{
    [self prepare];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        sleep(1.0);
        [self notify:kXCTUnitWaitStatusSuccess];
    });
    // Will wait for 2 seconds before expecting the test to have status success
    // Potential statuses are:
    //    kXCTUnitWaitStatusUnknown,    initial status
    //    kXCTUnitWaitStatusSuccess,    indicates a successful callback
    //    kXCTUnitWaitStatusFailure,    indicates a failed callback, e.g login operation failed
    //    kXCTUnitWaitStatusCancelled,  indicates the operation was cancelled
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:2.0];
}
```

xtesitfy.sh
----------
Script to automatically convert any old GHUnit test classes to Apple's new XCTests.
Will search for GHUnit's assertions and class names and replace them with the corresponding XCTest substitutions.