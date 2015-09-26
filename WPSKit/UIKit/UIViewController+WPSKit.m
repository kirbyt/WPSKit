//
//  UIViewController+WPSKit.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 1/17/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import "UIViewController+WPSKit.h"

@implementation UIViewController (WPSKit)

- (void)wps_clearBackButtonTitle
{
  [self wps_setBackButtonTitle:@""];
}

- (void)wps_setBackButtonTitle:(nullable NSString *)title
{
   UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
   [[self navigationItem] setBackBarButtonItem:backButton];
}

- (void)wps_setBackButtonChevron:(nullable UIImage *)image
{
  UINavigationBar *navBar = [[self navigationController] navigationBar];
  [navBar setBackIndicatorImage:image];
  [navBar setBackIndicatorTransitionMaskImage:image];
}

#pragma mark - Alert Helpers

- (void)wps_presentOkayAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message
{
  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okayAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"WPSKit", @"Alert button title") style:UIAlertActionStyleDefault handler:nil];
  [alertController addAction:okayAction];
  
  [self presentViewController:alertController animated:YES completion:nil];
}

- (void)wps_presentOkayAlertWithError:(nullable NSError *)error
{
  NSString *title = NSLocalizedStringFromTable(@"Error",  @"WPSKit", @"Alert title.");
  NSString *message = [error localizedDescription];
  [self wps_presentOkayAlertWithTitle:title message:message];
}

@end
