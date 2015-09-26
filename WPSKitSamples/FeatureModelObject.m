//
//  FeatureModelObject.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "FeatureModelObject.h"

NSString * const WPSFeatureKeyTitle = @"title";
NSString * const WPSFeatureKeyItems = @"items";
NSString * const WPSFeatureKeyViewControllerClassName = @"viewControllerClassName";


@implementation FeatureModelObject

+ (NSArray *)features
{
   NSString *defaultViewControllerClassName = @"WPSTableViewController";
   
   NSArray *tableViewItems = @[
                              @{
                                 WPSFeatureKeyTitle: @"Customizations",
                                 WPSFeatureKeyItems: @[
                                                         @{
                                                            WPSFeatureKeyTitle: @"Custom Detail Disclosure Button",
                                                            WPSFeatureKeyItems: @[],
                                          WPSFeatureKeyViewControllerClassName: @"WPSCustomDetailDisclosureButtonViewController"
                                                         }
                                                      ]
                                 }
                              ];
   
   NSArray *uiKitItems = @[
                           @{
                              WPSFeatureKeyTitle: @"UIApplication+WPSKit",
                              WPSFeatureKeyItems: @[],
                              WPSFeatureKeyViewControllerClassName: defaultViewControllerClassName,
                           },
                           @{
                              WPSFeatureKeyTitle: @"UIColor+WPSKit",
                              WPSFeatureKeyItems: @[],
                              WPSFeatureKeyViewControllerClassName: defaultViewControllerClassName,
                           },
                           @{
                              WPSFeatureKeyTitle: @"WPSTextView",
                              WPSFeatureKeyItems: @[],
                              WPSFeatureKeyViewControllerClassName: @"WPSTextViewController",
                           },
                          @{
                              WPSFeatureKeyTitle: @"UITableView",
                              WPSFeatureKeyItems: tableViewItems,
                              WPSFeatureKeyViewControllerClassName: defaultViewControllerClassName,
                           },
                        ];
   
   NSArray *foundationItems = @[
                                @{
                                   WPSFeatureKeyTitle: @"NSString+WPSKit",
                                   WPSFeatureKeyItems: @[],
                                   WPSFeatureKeyViewControllerClassName: defaultViewControllerClassName,
                                 },
                              ];
   
   NSArray *data = @[
                     @{
                        WPSFeatureKeyTitle: @"Core Data",
                        WPSFeatureKeyItems: @[],
                        },
                     @{
                        WPSFeatureKeyTitle: @"Core Location",
                        WPSFeatureKeyItems: @[],
                        },
                     @{
                        WPSFeatureKeyTitle: @"Foundation",
                        WPSFeatureKeyItems: foundationItems,
                        },
                     @{
                        WPSFeatureKeyTitle: @"MapKit",
                        WPSFeatureKeyItems: @[],
                        },
                     @{
                        WPSFeatureKeyTitle: @"UIKit",
                        WPSFeatureKeyItems: uiKitItems,
                        },
                     ];
   return data;
}

@end
