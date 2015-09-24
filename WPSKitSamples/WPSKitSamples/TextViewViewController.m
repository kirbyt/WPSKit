//
//  TextViewViewController.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "TextViewViewController.h"

@import WPSKit;

@implementation TextViewViewController

@synthesize textView = _textView;

- (id)initWithDefaultNib
{
   self = [super initWithNibName:@"TextViewView" bundle:nil];
   if (self) {
      
   }
   return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   [[self textView] setPlaceholderText:@"Tap to enter text."];
}

@end
