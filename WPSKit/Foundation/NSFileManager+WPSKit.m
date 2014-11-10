//
// WPSKit
// NSFileManager+WPSKit.m
//
// Created by Kirby Turner.
// Copyright 2011 White Peak Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "NSFileManager+WPSKit.h"

@implementation NSFileManager (WPSKit)

+ (void)wps_createDirectoryAtPath:(NSString *)path
{
   NSFileManager *fileManager = [[NSFileManager alloc] init];
   if (![fileManager fileExistsAtPath:path]) {
      NSError *error = nil;
      if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
         NSString *errorMsg = [NSString stringWithFormat:@"Could not find or create directory at path '%@'.", path];
         NSDictionary *errorInfo = @{NSUnderlyingErrorKey: error};
         NSException *directoryException = [NSException exceptionWithName:NSInternalInconsistencyException reason:errorMsg userInfo:errorInfo];
         
         @throw directoryException;
      }
   }
}

- (uint64_t)wps_fileSizeAtPath:(NSString *)path
{
  uint64_t bytes = 0;
  if ([self fileExistsAtPath:path]) {
    NSDictionary *attributes = [self attributesOfItemAtPath:path error:NULL];
    bytes = [attributes fileSize];
  }
  return bytes;
}

- (uint64_t)wps_fileSizeAtURL:(NSURL *)fileURL
{
  return [self wps_fileSizeAtPath:[fileURL path]];
}

@end
