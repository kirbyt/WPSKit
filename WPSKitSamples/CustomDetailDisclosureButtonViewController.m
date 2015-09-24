//
//  CustomDetailDisclosureButtonViewController.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 8/22/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import "CustomDetailDisclosureButtonViewController.h"
#import "CustomDetailDisclosureCell.h"

@import WPSKit;

@interface CustomDetailDisclosureButtonViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation CustomDetailDisclosureButtonViewController

- (id)initWithDefaultNib
{
   self = [super initWithNibName:@"CustomDetailDisclosureButtonViewController" bundle:nil];
   if (self) {

   }
   return self;
}

#pragma mark - UITableViewDataSource and UITableViewDelegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   NSInteger count = 1;
   return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   NSInteger count = 10;
   return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   CustomDetailDisclosureCell *cell = [CustomDetailDisclosureCell cellFromDefaultNibForTableView:tableView];
   
   NSString *text =[NSString stringWithFormat:@"Row %zi", [indexPath row]];
   [[cell textLabel] setText:text];
   
   return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
#warning Fix Me
//   NSString *message = [NSString stringWithFormat:@"Got it! (section: %zi, row: %zi)", [indexPath section], [indexPath row]];
//   [WPSAlertView presentOkayAlertViewWithTitle:@"Accessory Button Tapped" message:message];
}

@end
