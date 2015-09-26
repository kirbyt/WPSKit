//
//  AppDelegate.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "FeatureModelObject.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
   RootViewController *rootViewController = [[RootViewController alloc] init];
   [rootViewController setData:[FeatureModelObject features]];
   
   UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
   
   UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   [window setRootViewController:navController];
   [window setBackgroundColor:[UIColor whiteColor]];
   [window makeKeyAndVisible];
   [self setWindow:window];
   
   return YES;
}

@end
