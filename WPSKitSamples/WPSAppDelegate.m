//
//  AppDelegate.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "WPSAppDelegate.h"
#import "WPSTableViewController.h"
#import "FeatureModelObject.h"

@implementation WPSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   WPSTableViewController *vc = [[WPSTableViewController alloc] init];
   [vc setData:[FeatureModelObject features]];

   UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:vc];
   
   UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   [window setRootViewController:navController];
   [window setBackgroundColor:[UIColor whiteColor]];
   [window makeKeyAndVisible];
   [self setWindow:window];
   
   return YES;
}

@end
