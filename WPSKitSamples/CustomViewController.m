//
//  CustomViewController.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "CustomViewController.h"

@implementation CustomViewController

- (id)initWithDefaultNib
{
   NSException *exc = nil;
   NSString *reason = @"Must override initWithDefaultNib.";
   exc = [NSException exceptionWithName:NSInternalInconsistencyException reason:reason userInfo:nil];
   @throw exc;
}

@end
