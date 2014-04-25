//
//  UICollectionView+WPSKit.h
//  CrossPost
//
//  Created by Kirby Turner on 4/25/14.
//  Copyright (c) 2014 White Peak Software, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 This category adds methods to the UIKit framework’s `UICollectionView` class. The methods in this category provide support for commonly used tasks performed when working with instances of `UICollectionView`.
 */
@interface UICollectionView (WPSKit)

/**
 Scrolls the collection view to the last item.
 
 @param animated Specify `YES` to animate the scrolling behavior or `NO` to adjust the scroll view’s visible content immediately.
 */
- (void)wps_scrollToBottomItemAnimated:(BOOL)animated;

@end
