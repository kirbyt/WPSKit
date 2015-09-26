//
//  WPSAlertController.m
//  WPSKit
//
//  Created by Kirby Turner on 9/26/15.
//  Copyright © 2015 White Peak Software, Inc. All rights reserved.
//

#import "WPSAlertController.h"

@interface WPSAlertController ()
@property (nonatomic, strong) UIWindow *alertWindow;
@end

@implementation WPSAlertController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [[self alertWindow] setHidden:YES];
  [self setAlertWindow:nil];
}

- (void)show
{
  [self showAnimated:YES];
}

- (void)showAnimated:(BOOL)animated
{
  UIViewController *blankViewController = [[UIViewController alloc] init];
  [[blankViewController view] setBackgroundColor:[UIColor clearColor]];
  
  UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  [window setRootViewController:blankViewController];
  [window setBackgroundColor:[UIColor clearColor]];
  [window setWindowLevel:UIWindowLevelAlert + 1];
  [window makeKeyAndVisible];
  [self setAlertWindow:window];
  
  [blankViewController presentViewController:self animated:animated completion:nil];
}

+ (void)presentOkayAlertWithTitle:(nullable NSString *)title message:(nullable NSString *)message
{
  WPSAlertController *alertController = [WPSAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
  UIAlertAction *okayAction = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"OK", @"WPSKit", @"Alert button title") style:UIAlertActionStyleDefault handler:nil];
  [alertController addAction:okayAction];

  [alertController show];
}

+ (void)presentOkayAlertWithError:(nullable NSError *)error
{
  NSString *title = NSLocalizedStringFromTable(@"Error",  @"WPSKit", @"Alert title.");
  NSString *message = [error localizedDescription];
  [[self class] presentOkayAlertWithTitle:title message:message];
}

@end
