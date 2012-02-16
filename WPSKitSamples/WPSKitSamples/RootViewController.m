//
//  RootViewController.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 2/16/12.
//  Copyright (c) 2012 White Peak Software Inc. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
@property (nonatomic, strong) NSArray *data;
@end

@implementation RootViewController

@synthesize tableView = _tableView;
@synthesize data = _data;

- (id)initWithDefaultNib
{
   self = [super initWithNibName:@"RootView" bundle:nil];
   if (self) {
      
   }
   return self;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   
   [self setTitle:@"WPSKit Samples"];
   
   NSArray *data = [NSArray array];
   [self setData:data];
}

#pragma mark - UITableViewDelegate and UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   NSInteger count = [[self data] count];
   return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   NSDictionary *dict = [[self data] objectAtIndex:section];
   NSArray *items = [dict objectForKey:@"items"];
   NSInteger count = [items count];
   return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return nil;
}

@end
