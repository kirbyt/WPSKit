//
//  FeatureModelObject.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "FeatureModelObject.h"

NSString * const kWPSFeatureKeyTitle = @"title";
NSString * const kWPSFeatureKeyItems = @"items";
NSString * const kWPSFeatureKeyViewControllerClassName = @"viewControllerClassName";


@implementation FeatureModelObject

+ (NSArray *)features
{
   NSString *rootViewControllerClassName = @"RootViewController";
   
   NSArray *tableViewItems = @[
                              @{
                                 kWPSFeatureKeyTitle: @"Customizations",
                                 kWPSFeatureKeyItems: @[
                                                         @{
                                                            kWPSFeatureKeyTitle: @"Custom Detail Disclosure Button",
                                                            kWPSFeatureKeyItems: @[],
                                          kWPSFeatureKeyViewControllerClassName: @"CustomDetailDisclosureButtonViewController"
                                                         }
                                                      ]
                                 }
                              ];
   
   NSArray *uiKitItems = @[
                           @{
                              kWPSFeatureKeyTitle: @"UIApplication+WPSKit",
                              kWPSFeatureKeyItems: @[],
                              kWPSFeatureKeyViewControllerClassName: rootViewControllerClassName,
                           },
                           @{
                              kWPSFeatureKeyTitle: @"UIColor+WPSKit",
                              kWPSFeatureKeyItems: @[],
                              kWPSFeatureKeyViewControllerClassName: rootViewControllerClassName,
                           },
                           @{
                              kWPSFeatureKeyTitle: @"WPSTextView",
                              kWPSFeatureKeyItems: @[],
                              kWPSFeatureKeyViewControllerClassName: rootViewControllerClassName,
                           },
                          @{
                              kWPSFeatureKeyTitle: @"UITableView",
                              kWPSFeatureKeyItems: tableViewItems,
                              kWPSFeatureKeyViewControllerClassName: rootViewControllerClassName,
                           },
                        ];
   
   NSArray *foundationItems = @[
                                @{
                                   kWPSFeatureKeyTitle: @"NSString+WPSKit",
                                   kWPSFeatureKeyItems: @[],
                                   kWPSFeatureKeyViewControllerClassName: rootViewControllerClassName,
                                 },
                              ];
   
   NSArray *data = @[
                     @{
                        kWPSFeatureKeyTitle: @"Core Data",
                        kWPSFeatureKeyItems: @[],
                        },
                     @{
                        kWPSFeatureKeyTitle: @"Core Location",
                        kWPSFeatureKeyItems: @[],
                        },
                     @{
                        kWPSFeatureKeyTitle: @"Foundation",
                        kWPSFeatureKeyItems: foundationItems,
                        },
                     @{
                        kWPSFeatureKeyTitle: @"MapKit",
                        kWPSFeatureKeyItems: @[],
                        },
                     @{
                        kWPSFeatureKeyTitle: @"UIKit",
                        kWPSFeatureKeyItems: uiKitItems,
                        },
                     ];
   return data;
}

@end
