//
//  FeatureModelObject.h
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kWPSFeatureKeyTitle;
extern NSString * const kWPSFeatureKeyItems;
extern NSString * const kWPSFeatureKeyViewControllerClassName;

@interface FeatureModelObject : NSObject

+ (NSArray *)features;

@end
