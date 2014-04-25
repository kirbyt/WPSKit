//
//  UICollectionView+WPSKit.m
//  CrossPost
//
//  Created by Kirby Turner on 4/25/14.
//  Copyright (c) 2014 White Peak Software, Inc. All rights reserved.
//

#import "UICollectionView+WPSKit.h"

@implementation UICollectionView (WPSKit)

- (void)wps_scrollToBottomItemAnimated:(BOOL)animated
{
  NSInteger section = [self numberOfSections] - 1;
  NSInteger item = [self numberOfItemsInSection:section] - 1;
  NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:section];
  [self scrollToItemAtIndexPath:lastIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
}

@end
