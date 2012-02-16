//
//  FeatureModelObject.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "FeatureModelObject.h"
#import "RootViewController.h"

NSString * const kWPSFeatureKeyTitle = @"title";
NSString * const kWPSFeatureKeyItems = @"items";
NSString * const kWPSFeatureKeyViewControllerClassName = @"viewControllerClassName";


@implementation FeatureModelObject

+ (NSArray *)features
{
   NSString *rootViewControllerClassName = NSStringFromClass([RootViewController class]);
   
   NSArray *uiKitItems = [NSArray arrayWithObjects:
                          [NSDictionary dictionaryWithObjectsAndKeys:@"UIApplication+WPSKit", kWPSFeatureKeyTitle, [NSArray array], kWPSFeatureKeyItems, rootViewControllerClassName, kWPSFeatureKeyViewControllerClassName, nil],
                          [NSDictionary dictionaryWithObjectsAndKeys:@"UIColor+WPSKit", kWPSFeatureKeyTitle, [NSArray array], kWPSFeatureKeyItems, rootViewControllerClassName, kWPSFeatureKeyViewControllerClassName, nil],
                          nil];
   
   NSArray *data = [NSArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Core Data", kWPSFeatureKeyTitle, [NSArray array], kWPSFeatureKeyItems, nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Core Location", kWPSFeatureKeyTitle, [NSArray array], kWPSFeatureKeyItems, nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"Foundation", kWPSFeatureKeyTitle, [NSArray array], kWPSFeatureKeyItems, nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"MapKit", kWPSFeatureKeyTitle, [NSArray array], kWPSFeatureKeyItems, nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:@"UIKit", kWPSFeatureKeyTitle, uiKitItems, kWPSFeatureKeyItems, nil],
                    nil];
   return data;
}

@end
