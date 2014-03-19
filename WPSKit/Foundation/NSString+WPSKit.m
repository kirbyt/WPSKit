/**
 **   NSString+WPSKit
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

#import "NSString+WPSKit.h"

static const char _base64EncodingTable[64] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSString (WPSKit)

+ (NSString *)wps_stringWithData:(NSData *)data encoding:(NSStringEncoding)encoding
{
   NSString *result = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:encoding];
   return result;
}

+ (NSString *)wps_stringWithData:(NSData *)data
{
   return [self wps_stringWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSString *)wps_stringWithUUID
{
#ifdef __IPHONE_6_0 
   NSString *result = [[NSUUID UUID] UUIDString];
#else
   CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
   CFStringRef	uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
   
   // Create a new auto-release NSString to hold the UUID. This approach
   // is used to avoid leaking in a garbage collected environment.
   //
   // From the Apple docs:
   // It is important to appreciate the asymmetry between Core Foundation and
   // Cocoa—where retain, release, and autorelease are no-ops. If, for example,
   // you have balanced a CFCreate… with release or autorelease, you will leak
   // the object in a garbage collected environment:
   // http://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/GarbageCollection/Articles/gcCoreFoundation.html
   //
   NSString *result = [NSString stringWithString:(__bridge NSString *)uuidString];
   
   CFRelease(uuidRef);
   CFRelease(uuidString);
#endif
   
   return result;
}

+ (id)wps_emptyStringIfNil:(id)value
{
   return wps_emptyStringIfNil(value);
}

- (BOOL)wps_isURL
{
   NSURL *URL = [NSURL URLWithString:self];
   return (URL != nil);
}

- (BOOL)wps_containsSubstring:(NSString*)substring
{
   NSRange textRange = [[self lowercaseString] rangeOfString:[substring lowercaseString]];
   return (textRange.location != NSNotFound);
}

- (NSString*)wps_URLEncodedStringWithEncoding:(NSStringEncoding)encoding
{
   static NSString * const kTMLegalCharactersToBeEscaped = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\|~ ";
   
   CFStringRef encodedStringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, NULL, (__bridge CFStringRef)kTMLegalCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
   NSString *encodedString = (__bridge_transfer NSString *)encodedStringRef;
   // Note: Do not need to call CFRelease(encodedStringRef). This is done
   // for us by using __bridge_transfer.
   return [encodedString copy];
}

#pragma mark - Base64

/**
 * Base64 methods come from QSUtilities available at:
 * https://github.com/mikeho/QSUtilities
 *
 * Copyright (c) 2010 - 2011, Quasidea Development, LLC
 * For more information, please go to http://www.quasidea.com/
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

+ (NSString *)wps_base64StringWithString:(NSString *)string
{
	return [self wps_base64StringWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

/*
 Base64 Functions ported from PHP's Core
 
 +----------------------------------------------------------------------+
 | PHP Version 5                                                        |
 +----------------------------------------------------------------------+
 | Copyright (c) 1997-2010 The PHP Group                                |
 +----------------------------------------------------------------------+
 | This source file is subject to version 3.01 of the PHP license,      |
 | that is bundled with this package in the file LICENSE, and is        |
 | available through the world-wide-web at the following url:           |
 | http://www.php.net/license/3_01.txt                                  |
 | If you did not receive a copy of the PHP license and are unable to   |
 | obtain it through the world-wide-web, please send a note to          |
 | license@php.net so we can mail you a copy immediately.               |
 +----------------------------------------------------------------------+
 | Author: Jim Winstead <jimw@php.net>                                  |
 +----------------------------------------------------------------------+
 */

+ (NSString *)wps_base64StringWithData:(NSData *)data
{
	const unsigned char * objRawData = [data bytes];
	char * objPointer;
	char * strResult;
   
	// Get the Raw Data length and ensure we actually have data
	size_t intLength = [data length];
	if (intLength == 0) return nil;
   
	// Setup the String-based Result placeholder and pointer within that placeholder
	strResult = (char *)calloc(((intLength + 2) / 3) * 4, sizeof(char));
	objPointer = strResult;
   
	// Iterate through everything
	while (intLength > 2) { // keep going until we have less than 24 bits
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
		*objPointer++ = _base64EncodingTable[((objRawData[1] & 0x0f) << 2) + (objRawData[2] >> 6)];
		*objPointer++ = _base64EncodingTable[objRawData[2] & 0x3f];
      
		// we just handled 3 octets (24 bits) of data
		objRawData += 3;
		intLength -= 3;
	}
   
	// now deal with the tail end of things
	if (intLength != 0) {
		*objPointer++ = _base64EncodingTable[objRawData[0] >> 2];
		if (intLength > 1) {
			*objPointer++ = _base64EncodingTable[((objRawData[0] & 0x03) << 4) + (objRawData[1] >> 4)];
			*objPointer++ = _base64EncodingTable[(objRawData[1] & 0x0f) << 2];
			*objPointer++ = '=';
		} else {
			*objPointer++ = _base64EncodingTable[(objRawData[0] & 0x03) << 4];
			*objPointer++ = '=';
			*objPointer++ = '=';
		}
	}
   
	NSString *strToReturn = [[NSString alloc] initWithBytesNoCopy:strResult length:(NSUInteger)(objPointer - strResult) encoding:NSASCIIStringEncoding freeWhenDone:YES];
	return strToReturn;
}

@end
