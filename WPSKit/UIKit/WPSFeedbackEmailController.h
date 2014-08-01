//
// WPSFeedbackEmailController.h
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

@import MessageUI;

/**
 `WPSFeedbackEmailController` is used to present and send feedback email.
 
 Example usage:
 
   WPSFeedbackEmailController *feedbackController = [[WPSFeedbackEmailController alloc] init];
   [feedbackController setToRecipients:@[@"support@whitepeaksoftware.com"]];
   [feedbackController setWebsiteURL:[NSURL URLWithString:@"http://www.whitepeaksoftware.com/support/"]];
   [feedbackController setStyleMailComposer:^(MFMailComposeViewController *mailer) {
     [[mailer navigationBar] setBarTintColor:[UIColor blackColor]];
     [[mailer navigationBar] setTintColor:[UIColor wps_colorWithHex:0x4eb88c]];
     UIFont *font = [UIFont wps_defaultFontWithSize:17.0];
     [[mailer navigationBar] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:font}];
   }];
   [feedbackController presentFromViewController:self completion:^{
     [self setFeedbackController:nil];
   }];
   [self setFeedbackController:feedbackController];
 
 */
@interface WPSFeedbackEmailController : NSObject <MFMailComposeViewControllerDelegate>

/**
 The website URL to display if the device is not configured for sending emails.
 */
@property (nonatomic, strong) NSURL *websiteURL;

/**
 An array of `NSString` objects, each of which contains the email address of a single recipient.
 */
@property (nonatomic, copy) NSArray *toRecipients;

/**
 This block is called prior to presenting the mail composer. This gives the caller a chance to customize the style used by the `MFMailComposeViewController` instance.
 
 You should set the block before presenting the mail composer.
 */
@property (nonatomic, copy) void (^styleMailComposer)(MFMailComposeViewController *mailComposer);

/**
 Present the mail composer.
 
 If the device is not configured for sending email and `websiteURL` is not `nil`, then the the website is displayed in Safari.
 
 @param viewController The view controller responsible for presenting the mail composer.
 @param completion The block that is executed once the mail composer is dismissed.
 */
- (void)presentFromViewController:(UIViewController *)viewController completion:(void (^)())completion;

/**
 Returns a Boolean indicating whether the current device is able to send email.
 
 @return `YES` if the device is configured for sending email or `NO` if it is not.
 */
+ (BOOL)canSendMail;

@end
