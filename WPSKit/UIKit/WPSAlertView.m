/**
 **   WPSAlertView
 **
 **   Created by Kirby Turner.
 **   Copyright (c) 2011 White Peak Software. All rights reserved.
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

#import "WPSAlertView.h"

@interface WPSAlertView ()
@property (nonatomic, copy) WPSAlertViewCompletionBlock completion;
@end

@implementation WPSAlertView

+ (WPSAlertView *)okayAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
   NSString *okButtonTitle = NSLocalizedString(@"OK", @"OK button title.");
   WPSAlertView *alert = [[WPSAlertView alloc] initWithTitle:title message:message completion:nil cancelButtonTitle:okButtonTitle otherButtonTitles:nil];
   return alert;
}

+ (WPSAlertView *)cancelOkayAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
   NSString *okButtonTitle = NSLocalizedString(@"OK", @"OK button title for WPSAlertView.");
   NSString *cancelButtonTitle = NSLocalizedString(@"Cancel", @"Cancel button title for WPSAlertView.");
   WPSAlertView *alert = [[WPSAlertView alloc] initWithTitle:title message:message completion:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:okButtonTitle, nil];
   return alert;
}

+ (void)presentOkayAlertViewWithTitle:(NSString *)title message:(NSString *)message
{
   WPSAlertView *alert = [self okayAlertViewWithTitle:title message:message];
   [alert show];
}

- (void)dealloc
{
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
   [nc removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)commonInit
{
   NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
   [nc addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (id)initWithCompletion:(WPSAlertViewCompletionBlock)completion
{
   self = [super init];
   if (self) {
      [self commonInit];
      [self setDelegate:self];
      [self setCompletion:completion];
   }
   return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message completion:(WPSAlertViewCompletionBlock)completion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
   self = [super init];
   if (self) {
      [self commonInit];
      
      [self setTitle:title];
      [self setMessage:message];
      [self setDelegate:self];
      
      if (cancelButtonTitle) {
         [self addButtonWithTitle:cancelButtonTitle];
         [self setCancelButtonIndex:[self numberOfButtons] - 1];
      }
      
      va_list args;
      va_start(args, otherButtonTitles);
      for (NSString *arg = otherButtonTitles; arg != nil; arg = va_arg(args, NSString*))
      {
         [self addButtonWithTitle:arg];
      }
      va_end(args);
      
      
      [self setCompletion:completion];
   }
   return self;
}

#pragma mark - UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   WPSAlertViewCompletionBlock completion = [self completion];
   if (completion) {
      completion(self, buttonIndex);
   }
}

#pragma mark - Notifications

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
   if ([self dismissOnBackground]) {
      NSInteger cancelButtonIndex = [self cancelButtonIndex];
      if (cancelButtonIndex >= 0)
         [self dismissWithClickedButtonIndex:cancelButtonIndex animated:NO];
   }
}

@end

#pragma mark - UIViewController Category

@implementation UIViewController (WPSKitAlertView)

- (void)wps_alertUserWithError:(NSError *)error
{
   NSString *title = NSLocalizedString(@"Error", @"Error title.");
   NSString *message = [error localizedDescription];
   WPSAlertView *alert = [WPSAlertView okayAlertViewWithTitle:title message:message];
   [alert show];
}

@end
