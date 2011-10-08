/**
 **   NetworkActivityTests
 **
 **   Created by Kirby Turner.
 **   Copyright 2011 White Peak Software. All rights reserved.
 **
 **   Permission is hereby granted, free of charge, to any person obtaining 
 **   a copy of this software and associated documentation files (the 
 **   "Software"), to deal in the Software without restriction, including 
 **   without limitation the rights to use, copy, modify, merge, publish, 
 **   distribute, sublicense, and/or sell copies of the Software, and to permit 
 **   persons to whom the Software is furnished to do so, subject to the 
 **   following conditions:
 **
 **   The above copyright notice and this permission notice shall be included 
 **   in all copies or substantial portions of the Software.
 **
 **   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS 
 **   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 **   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 **   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 **   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 **   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 **   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **
 **/

#import "NetworkActivityTests.h"
#import "UIApplication+WPSCategory.h"

@implementation NetworkActivityTests

- (void)testNetworkActivity
{
   UIApplication *app = [UIApplication sharedApplication];
   STAssertNotNil(app, @"Cannot perform tests with nil UIApplication object.");
   STAssertTrue([app wps_networkActivityCount] == 0, @"Unexpected count.");
   
   [app wps_pushNetworkActivity];
   [app wps_pushNetworkActivity];
   STAssertTrue([app wps_networkActivityCount] == 2, @"Unexpected count. %i", [app wps_networkActivityCount]);

   [app wps_popNetworkActivity];
   STAssertTrue([app wps_networkActivityCount] == 1, @"Unexpected count. %i", [app wps_networkActivityCount]);
   
   [app wps_popNetworkActivity];
   [app wps_popNetworkActivity]; // Purposely unbalance the network activity counter.
   STAssertTrue([app wps_networkActivityCount] == 0, @"Unexpected count. %i", [app wps_networkActivityCount]);
   
   [app wps_pushNetworkActivity];
   [app wps_pushNetworkActivity];
   [app wps_pushNetworkActivity];
   STAssertTrue([app wps_networkActivityCount] == 3, @"Unexpected count. %i", [app wps_networkActivityCount]);
   
   [app wps_resetNetworkActivity];
   STAssertTrue([app wps_networkActivityCount] == 0, @"Unexpected count. %i", [app wps_networkActivityCount]);
}

@end
