//
//  FeatureModelObject.h
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const WPSFeatureKeyTitle;
extern NSString * const WPSFeatureKeyItems;
extern NSString * const WPSFeatureKeyViewControllerClassName;

@interface FeatureModelObject : NSObject

+ (NSArray *)features;

@end
