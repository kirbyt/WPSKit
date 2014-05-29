//
// WPSActivityTracker.h
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

#import <Foundation/Foundation.h>

/**
 Activity tracker tracks tasks for an activity and executes the completed block when all tasks have completed.
 */
@interface WPSActivityTracker : NSObject

/**
 The block that is executed when all tasks for the activity have ended.
 
 This block is executed on the main thread.
 
 @param taskErrors A set of errors reported by tasks.
 */
@property (nonatomic, copy) void (^activityCompletedBlock)(NSSet *taskErrors);

/**
 Initializes the `WPSActivityTracker` object with a provided task count. This is the same as calling `-beginTask` for `taskCount` number of times.
 
 Use this when you want a countdown style activity tracker.
 
 @param taskCount The initial "running" task count.
 @return An instance of `WPSActivityTracker`.
 */
- (instancetype)initWithTaskCount:(NSUInteger)taskCount;

/**
 Immediately ends the activity. 
 
 Calling this will execute the `activityCompletedBlock` block.
 */
- (void)cancelActivity;

/**
 Tells the activity tracker that a task has started.
 
 This increments the task counter.
 */
- (void)beginTask;

/**
 Tells the activity tracker that a task has ended.
 
 This decrements the task counter. The `activityCompletedBlock` block is executed when the task counter reaches zero.
 */
- (void)endTask;

/**
 Tells the activity tracker that a task has ended with an error.
 
 This decrements the task counter. The `activityCompletedBlock` block is executed when the task counter reaches zero.

 @param error The error reported by the task.
 */
- (void)endTaskWithError:(NSError *)error;

@end
