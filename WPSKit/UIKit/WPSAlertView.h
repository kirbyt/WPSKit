//
// WPSAlertView.h
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

#import <UIKit/UIKit.h>

@class WPSAlertView;

typedef void(^WPSAlertViewCompletionBlock)(WPSAlertView *alertView, NSInteger buttonIndex);

/**
 Provides a block-based implementation of `UIAlertView`.
 */
@interface WPSAlertView : UIAlertView <UIAlertViewDelegate>


+ (WPSAlertView *)okayAlertViewWithTitle:(NSString *)title message:(NSString *)message;

+ (WPSAlertView *)cancelOkayAlertViewWithTitle:(NSString *)title message:(NSString *)message;

+ (void)presentOkayAlertViewWithTitle:(NSString *)title message:(NSString *)message;

/**
 Presents an alert displaying information from the provided `NSError` object.

 @param error The error object containing the data to present in the alert.
 */
+ (void)presentOkayAlertViewWithError:(NSError *)error;

- (id)initWithCompletion:(WPSAlertViewCompletionBlock)completion;

- (id)initWithTitle:(NSString *)title message:(NSString *)message completion:(WPSAlertViewCompletionBlock)completion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Set to YES to automatically dismiss the action sheet when the application
 enters the background. The default is NO.

 Note: You must specify a cancel button to dismiss on the background.
 */
@property (nonatomic, assign) BOOL dismissOnBackground;

@end

@interface UIViewController (WPSKitAlertView)

- (void)wps_alertUserWithError:(NSError *)error;

@end
