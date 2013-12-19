//
//  WebClientViewController.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "WebClientViewController.h"
#import "WPSWebClient.h"
#import "NSString+WPSKit.h"
#import "WPSTextView.h"

@implementation WebClientViewController

@synthesize textView = _textView;
@synthesize activityIndicator = _activityIndicator;

- (id)initWithDefaultNib
{
   self = [super initWithNibName:@"WebClientView" bundle:nil];
   if (self) {
      
   }
   return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   WPSWebClientCompletionBlock completion = ^(NSURL *responseURL, NSData *data, BOOL hitCache, NSString *cacheKey, NSError *error) {
      NSString *text;
      if (data) {
         text = [NSString wps_stringWithData:data];
         
      } else {
         text = [NSString stringWithFormat:@"Error: %@\n%@", [error localizedDescription], [error userInfo]];
      }
      [[self activityIndicator] stopAnimating];
      [[self textView] setText:text];
   };
   
   [[self activityIndicator] setHidesWhenStopped:YES];
   [[self activityIndicator] startAnimating];
   
   NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"kirbyt", @"screen_name", nil];
   NSURL *URL = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/user_timeline.json"];
   WPSWebClient *webClient = [[WPSWebClient alloc] init];
   [webClient get:URL parameters:parameters completion:completion];
}

@end
