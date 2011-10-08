/**
 **   UIApplication+WPSCategory
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

#import "UIApplication+WPSCategory.h"
#import "NSFileManager+WPSCategory.h"

@implementation UIApplication (WPSCategory)

#pragma mark - User Domain Methods

+ (NSString *)wps_userDomainPathForDirectory:(NSSearchPathDirectory)searchPathDirectory pathComponent:(NSString *)pathComponent
{
   NSString *directory = [NSSearchPathForDirectoriesInDomains(searchPathDirectory, NSUserDomainMask, YES) lastObject];
   if (pathComponent) {
      directory = [directory stringByAppendingPathComponent:pathComponent];
   }
   [NSFileManager wps_createDirectoryAtPath:directory];
   
   return directory;
}

+ (NSURL *)wps_userDomainURLForDirectory:(NSSearchPathDirectory)searchPathDirectory pathComponent:(NSString *)pathComponent
{
   NSURL *URL = [[[NSFileManager defaultManager] URLsForDirectory:searchPathDirectory inDomains:NSUserDomainMask] lastObject];
   if (pathComponent) {
      URL = [URL URLByAppendingPathComponent:pathComponent];
   }
   return URL;
}

#pragma mark - Document Directory

+ (NSString *)wps_documentDirectory 
{
   return [self wps_userDomainPathForDirectory:NSDocumentDirectory pathComponent:nil];
}

+ (NSString *)wps_documentDirectoryByAppendingPathComponent:(NSString *)pathComponent
{
   return [self wps_userDomainPathForDirectory:NSDocumentDirectory pathComponent:pathComponent];
}

+ (NSURL *)wps_documentDirectoryURL
{
   return [self wps_userDomainURLForDirectory:NSDocumentDirectory pathComponent:nil];
}

+ (NSURL *)wps_documentDirectoryURLByAppendingPathComponent:(NSString *)pathComponent
{
   return [self wps_userDomainURLForDirectory:NSDocumentDirectory pathComponent:pathComponent];
}

#pragma mark - Cache Directory

+ (NSString *)wps_cacheDirectory
{
   return [self wps_userDomainPathForDirectory:NSCachesDirectory pathComponent:nil];
}

+ (NSString *)wps_cacheDirectoryByAppendingPathComponent:(NSString *)pathComponent
{
   return [self wps_userDomainPathForDirectory:NSCachesDirectory pathComponent:pathComponent];
}

+ (NSURL *)wps_cacheDirectoryURL
{
   return [self wps_userDomainURLForDirectory:NSCachesDirectory pathComponent:nil];
}

+ (NSURL *)wps_cacheDirectoryURLByAppendingPathComponent:(NSString *)pathComponent
{
   return [self wps_userDomainURLForDirectory:NSCachesDirectory pathComponent:pathComponent];
}

#pragma mark - Temporary Directory

+ (NSString *)wps_temporaryDirectory
{
   return NSTemporaryDirectory();
}

+ (NSString *)wps_temporaryDirectoryByAppendingPathComponent:(NSString *)pathComponent
{
   NSString *directory = [self wps_temporaryDirectory];
   if (pathComponent) {
      directory = [directory stringByAppendingPathComponent:pathComponent];
      [NSFileManager wps_createDirectoryAtPath:directory];
   }
   return directory;
}

+ (NSURL *)wps_temporaryDirectoryURL
{
   NSString *directory = [self wps_temporaryDirectory];
   NSURL *URL = [NSURL URLWithString:directory];
   return URL;
}

+ (NSURL *)wps_temporaryDirectoryURLByAppendingPathComponent:(NSString *)pathComponent
{
   NSURL *URL = [self wps_temporaryDirectoryURL];
   if (pathComponent) {
      URL = [URL URLByAppendingPathComponent:pathComponent];
   }
   return URL;
}

@end
