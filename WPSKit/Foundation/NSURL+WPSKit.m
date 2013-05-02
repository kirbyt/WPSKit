/**
 **   NSURL+WPSKit.m
 **
 **   Created by Kirby Turner.
 **   Copyright (c) 2013 White Peak Software. All rights reserved.
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

#import "NSURL+WPSKit.h"

@implementation NSURL (WPSKit)

- (NSDictionary *)wps_queryDictionary
{
   /**
    The following code is derived from the SSToolKit (under MIT).
    https://github.com/samsoffes/sstoolkit
    */
   
   NSString *encodedString = [self query];
   if (!encodedString) {
      return nil;
   }
   
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	NSArray *pairs = [encodedString componentsSeparatedByString:@"&"];
   
	for (NSString *kvp in pairs) {
		if ([kvp length] == 0) {
			continue;
		}
      
		NSRange pos = [kvp rangeOfString:@"="];
		NSString *key;
		NSString *val;
      
		if (pos.location == NSNotFound) {
			key = [self stringByUnescapingFromURLQuery:kvp];
			val = @"";
		} else {
			key = [self stringByUnescapingFromURLQuery:[kvp substringToIndex:pos.location]];
			val = [self stringByUnescapingFromURLQuery:[kvp substringFromIndex:pos.location + pos.length]];
		}
      
		if (!key || !val) {
			continue; // I'm sure this will bite my arse one day
		}
      
		[result setObject:val forKey:key];
	}
	return result;
}

- (BOOL)wps_isEqualToURL:(NSURL *)URL
{
   BOOL isEqual = NO;
   if ([[self scheme] isEqualToString:[URL scheme]] &&
       [[self host] isEqualToString:[URL host]] &&
       [[self path] isEqualToString:[URL path]]) {
      
      NSNumber *port = [self portWithDefault:@80];
      NSNumber *compareToPort = [URL portWithDefault:@80];
      if ([port isEqualToNumber:compareToPort]) {
         isEqual = YES;
      }
   }
   return isEqual;
}

- (NSNumber *)portWithDefault:(NSNumber *)defaultPort
{
   NSNumber *port = [self port];
   if (!port) {
      port = defaultPort;
   }
   return port;
}

#pragma mark - URL Escaping and Unescaping

- (NSString *)stringByUnescapingFromURLQuery:(NSString *)string
{
	NSString *deplussed = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
   return [deplussed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
