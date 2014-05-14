/**
 **   UIView+WPSKit.h
 **
 **   Created by Kirby Turner.
 **   Copyright (c) 2012 White Peak Software. All rights reserved.
 **
 **   Permission is hereby granted, free of charge, to any person obtaining
 **   a copy of this software and associated documentation files (the
 **   "Software"), to deal in the Software without restriction, including
 **   without limitation the rights to use, copy, modify, merge, publish,
 **   distribute, sublicense, and/or sell copies of the Software, and to permit
 **   persons to whom the Software is furnished to do so, subject to the
 **   following conditions:
 **
 **   The above copyright notice and this permission notice shall be included
 **   in all copies or substantial portions of the Software.
 **
 **   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 **   OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 **   MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 **   IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 **   CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 **   TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 **   SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 **
 **/

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(unsigned long, WPSViewPinEdges){
    WPSViewPinTopEdge = 1 << 0,
    WPSViewPinRightEdge = 1 << 1,
    WPSViewPinBottomEdge = 1 << 2,
    WPSViewPinLeftEdge = 1 << 3,
    WPSViewPinAllEdges = ~0UL
};

@interface UIView (WPSKit)

/**
 Displays the view's frame in the provided color.
 
 This is used as a debugging tool. It provides a visual aid to show you the frame of the view while the app is running.
 */
- (void)wps_showFrameWithColor:(UIColor *)color;

#pragma mark - Auto Layout Methods
/// @name Auto Layout Methods

- (NSArray *)wps_pinToSuperviewEdges:(WPSViewPinEdges)edges inset:(CGFloat)inset;
- (NSArray *)wps_pinToSuperviewEdgesWithInset:(UIEdgeInsets)insets;
- (void)wps_removeAllConstraints;

- (NSLayoutConstraint *)wps_constrainToHeight:(CGFloat)height;
- (NSLayoutConstraint *)wps_constrainToWidth:(CGFloat)width;
- (NSLayoutConstraint *)wps_constrainToHeightGreaterThanOrEqualTo:(CGFloat)height;
- (NSLayoutConstraint *)wps_constrainToWidthGreaterThanOrEqualTo:(CGFloat)width;

-(void)wps_centerInView:(UIView *)superview;
-(void)wps_centerInContainerOnAxis:(NSLayoutAttribute)axis;

#pragma mark - View Snapshot
/// @name View Snapshot

/**
 Returns a snapshot image of the view in its current state.
 
 @return A snapshot image.
 */
- (UIImage *)wps_imageSnapshot;

#pragma mark - Borders
/// @name Borders

/**
 Adds a 1 pixel border in the provided color to the top of the view's frame.
 
 @param color The color of the border.
 @return The `CALayer` that is used to draw the border.
 */
- (CALayer *)wps_addTopBorderWithColor:(UIColor *)color;

/**
 Adds a 1 pixel border in the provided color to the left side of the view's frame.
 
 @param color The color of the border.
 @return The `CALayer` that is used to draw the border.
 */
- (CALayer *)wps_addLeftBorderWithColor:(UIColor *)color;

/**
 Adds a 1 pixel border in the provided color to the right side of the view's frame.
 
 @param color The color of the border.
 @return The `CALayer` that is used to draw the border.
 */
- (CALayer *)wps_addRightBorderWithColor:(UIColor *)color;

/**
 Adds a 1 pixel border in the provided color to the bottom of the view's frame.
 
 @param color The color of the border.
 @return The `CALayer` that is used to draw the border.
 */
- (CALayer *)wps_addBottomBorderWithColor:(UIColor *)color;

@end
