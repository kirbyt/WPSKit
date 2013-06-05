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

- (NSArray *)wps_pinToSuperviewEdges:(WPSViewPinEdges)edges inset:(CGFloat)inset;
- (NSArray *)wps_pinToSuperviewEdgesWithInset:(UIEdgeInsets)insets;
- (void)wps_removeAllConstraints;

- (void)wps_constrainToHeight:(CGFloat)height;
- (void)wps_constrainToWidth:(CGFloat)width;
- (void)wps_constrainToHeightGreaterThanOrEqualTo:(CGFloat)height;
- (void)wps_constrainToWidthGreaterThanOrEqualTo:(CGFloat)width;

-(void)wps_centerInView:(UIView *)superview;
-(void)wps_centerInContainerOnAxis:(NSLayoutAttribute)axis;

@end
