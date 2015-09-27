//
// WPSAlertController.h
//
// Created by Kirby Turner.
// Copyright 2015 White Peak Software. All rights reserved.
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
