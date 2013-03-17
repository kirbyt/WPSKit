//
//  NSURL+WPSKit.m
//  WPSKitTests
//
//  Created by Kirby Turner on 3/16/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

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

#pragma mark - URL Escaping and Unescaping

- (NSString *)stringByUnescapingFromURLQuery:(NSString *)string
{
	NSString *deplussed = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
   return [deplussed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
