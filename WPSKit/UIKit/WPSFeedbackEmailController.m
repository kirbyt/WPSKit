//
// WPSFeedbackEmailController.m
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

#import "WPSFeedbackEmailController.h"
#import "UIApplication+WPSKit.h"

@interface WPSFeedbackEmailController ()
@property (nonatomic, copy) void (^completionBlock)();
@property (nonatomic, weak) UIViewController *viewController;
@end

@implementation WPSFeedbackEmailController

+ (BOOL)canSendMail
{
  return [MFMailComposeViewController canSendMail];
}

- (void)presentFromViewController:(UIViewController *)viewController completion:(void (^)())completion
{
  NSParameterAssert(viewController);
  [self setViewController:viewController];
  [self setCompletionBlock:completion];
  
  if ([[self class] canSendMail] == NO) {
    [self redirectUserToWebsite];
    return;
  }
  
  MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
  [mailer setMailComposeDelegate:self];
  [mailer setToRecipients:[self toRecipients]];
  [mailer setSubject:[NSString stringWithFormat:@"%@", [UIApplication wps_appName]]];
  [mailer setMessageBody:[self body] isHTML:NO];
  
  if (self.styleMailComposer) {
    self.styleMailComposer(mailer);
  }

  [viewController presentViewController:mailer animated:YES completion:nil];
}

#pragma mark - Helpers 

- (NSString *)body
{
  NSString *appName = [UIApplication wps_appName];
  NSString *appVersion = [UIApplication wps_appVersion];
  
  NSMutableString *body = [[NSMutableString alloc] init];
  [body appendFormat:@"\n\n\n----\n"];
  [body appendFormat:@"%@ %@\n", appName, appVersion];
  UIDevice *currentDevice = [UIDevice currentDevice];
  [body appendFormat:@"iOS Version %@ on %@\n----\n\n", [currentDevice systemVersion], [currentDevice model]];
  
  return [body copy];
}

- (void)redirectUserToWebsite
{
  NSURL *URL = [self websiteURL];
  if (URL) {
    [[UIApplication sharedApplication] openURL:URL];
  }
  
  if (self.completionBlock) {
    self.completionBlock();
  }
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
  UIViewController *viewController = [self viewController];
  [viewController dismissViewControllerAnimated:YES completion:nil];
  
  if (self.completionBlock) {
    self.completionBlock();
  }
}

@end
