//
//  WPSTextViewController.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 9/26/15.
//  Copyright © 2015 White Peak Software Inc. All rights reserved.
//

#import "WPSTextViewController.h"

@import WPSKit;

@interface WPSTextViewController ()
@property (nonatomic, strong) WPSTextView *textView;
@end

@implementation WPSTextViewController

- (void)loadView
{
   [super loadView];
   UIView *containerView = [self view];
   [containerView setBackgroundColor:[UIColor whiteColor]];
   
   WPSTextView *textView = [[WPSTextView alloc] initWithFrame:CGRectZero];
   [textView setTranslatesAutoresizingMaskIntoConstraints:NO];
   [textView setFont:[UIFont systemFontOfSize:17.0]];
   [textView setPlaceholderColor:[UIColor lightGrayColor]];
   [textView setPlaceholderText:@"Tap to enter text."];
   [self setTextView:textView];
   
   [containerView addSubview:textView];
   
   [textView wps_pinToSuperviewEdges:WPSViewPinLeftEdge|WPSViewPinRightEdge|WPSViewPinTopEdge inset:8.0f];
   [textView wps_constrainToHeight:200.0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

@end
