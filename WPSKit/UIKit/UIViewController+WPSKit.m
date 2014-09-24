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

- (void)wps_setBackButtonTitle:(NSString *)title
{
   UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
   [[self navigationItem] setBackBarButtonItem:backButton];
}

- (void)wps_setBackButtonChevron:(UIImage *)image
{
  UINavigationBar *navBar = [[self navigationController] navigationBar];
  [navBar setBackIndicatorImage:image];
  [navBar setBackIndicatorTransitionMaskImage:image];
}

@end
