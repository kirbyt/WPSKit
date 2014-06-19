//
// WPSActivityTracker.m
//
// Created by Kirby Turner.
// Copyright 2014 White Peak Software. All rights reserved.
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

#import "WPSActivityTracker.h"

@interface WPSActivityTracker ()
@property (nonatomic, assign) NSUInteger taskCount;
@property (nonatomic, strong) NSMutableSet *taskErrors;
@end

@implementation WPSActivityTracker

- (instancetype)init
{
  return [self initWithTaskCount:0];
}

- (instancetype)initWithTaskCount:(NSUInteger)taskCount
{
  self = [super init];
  if (self) {
    [self setTaskCount:taskCount];
    [self setTaskErrors:[NSMutableSet set]];
  }
  return self;
}

- (void)cancelActivity
{
  [self setTaskCount:0];
  if (self.activityCompletedBlock) {
    NSSet *taskErrors = [[self taskErrors] copy];
    dispatch_async(dispatch_get_main_queue(), ^{
      self.activityCompletedBlock(taskErrors);
    });
  }
}

- (void)cancelActivityWithError:(NSError *)error
{
  [[self taskErrors] addObject:[error copy]];
  [self cancelActivity];
}

- (void)beginTask
{
  NSUInteger taskCount = [self taskCount] + 1;
  [self setTaskCount:taskCount];
}

- (void)endTask
{
  NSUInteger taskCount = [self taskCount] - 1;
  [self setTaskCount:taskCount];
  if (taskCount == 0) {
    if (self.activityCompletedBlock) {
      NSSet *taskErrors = [[self taskErrors] copy];
      dispatch_async(dispatch_get_main_queue(), ^{
        self.activityCompletedBlock(taskErrors);
      });
    }
  }
}

- (void)endTaskWithError:(NSError *)error
{
  [[self taskErrors] addObject:[error copy]];
  [self endTask];
}

@end
