//
//  WPSCollectionViewCell.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/1/14.
//  Copyright (c) 2014 White Peak Software Inc. All rights reserved.
//

#import "WPSCollectionViewCell.h"

@implementation WPSCollectionViewCell

+ (NSString *)cellIdentifier
{
   return NSStringFromClass([self class]);
}

#pragma mark - NIB Support

+ (UINib *)nib
{
   NSBundle *classBundle = [NSBundle bundleForClass:[self class]];
   return [UINib nibWithNibName:[self nibName] bundle:classBundle];
}

+ (NSString *)nibName
{
   return [self cellIdentifier];
}

@end
