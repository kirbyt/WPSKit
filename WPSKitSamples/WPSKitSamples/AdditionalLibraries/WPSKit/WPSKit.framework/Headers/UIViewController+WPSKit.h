//
//  UIViewController+WPSKit.h
//  WPSKitSamples
//
//  Created by Kirby Turner on 1/17/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WPSKit)

- (void)wps_clearBackButtonTitle;
- (void)wps_setBackButtonTitle:(NSString *)title;
- (void)wps_setBackButtonChevron:(UIImage *)image;

@end
