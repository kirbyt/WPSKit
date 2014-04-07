/**
 **   UIView+WPSKit.m
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

#import "UIView+WPSKit.h"

@implementation UIView (WPSKit)

#pragma mark - Auto Layout Methods

/**
    The auto layout code is inspired and derived from the following 
    open source projects:
 
    https://github.com/jrturton/UIView-Autolayout
 */

- (NSArray *)wps_pinToSuperviewEdges:(WPSViewPinEdges)edges inset:(CGFloat)inset
{
    UIView *superview = [self superview];
    NSAssert(superview,@"Cannot pin to a non-existing superview.");
    
    NSMutableArray *constraints = [NSMutableArray array];
    
    if (edges & WPSViewPinTopEdge)
    {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:inset]];
    }
    if (edges & WPSViewPinLeftEdge)
    {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:inset]];
    }
    if (edges & WPSViewPinRightEdge)
    {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-inset]];
    }
    if (edges & WPSViewPinBottomEdge)
    {
        [constraints addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-inset]];
    }
    [superview addConstraints:constraints];
    return [constraints copy];
}

- (NSArray *)wps_pinToSuperviewEdgesWithInset:(UIEdgeInsets)insets
{
    NSAssert([self superview],@"Cannot pin to a non-existing superview.");
    
    NSMutableArray *constraints = [NSMutableArray new];
    
    [constraints addObjectsFromArray:[self wps_pinToSuperviewEdges:WPSViewPinTopEdge inset:insets.top]];
    [constraints addObjectsFromArray:[self wps_pinToSuperviewEdges:WPSViewPinLeftEdge inset:insets.left]];
    [constraints addObjectsFromArray:[self wps_pinToSuperviewEdges:WPSViewPinBottomEdge inset:insets.bottom]];
    [constraints addObjectsFromArray:[self wps_pinToSuperviewEdges:WPSViewPinRightEdge inset:insets.right]];
    
    return [constraints copy];
}

- (void)wps_removeAllConstraints
{
    NSArray *constraints = [self constraints];
    [self removeConstraints:constraints];
}

- (NSLayoutConstraint *)wps_constrainToHeight:(CGFloat)height
{
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:height];
  [self addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)wps_constrainToWidth:(CGFloat)width
{
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:width];
  [self addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)wps_constrainToHeightGreaterThanOrEqualTo:(CGFloat)height
{
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:0 multiplier:0 constant:height];
  [self addConstraint:constraint];
  return constraint;
}

- (NSLayoutConstraint *)wps_constrainToWidthGreaterThanOrEqualTo:(CGFloat)width
{
  NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:0 multiplier:0 constant:width];
  [self addConstraint:constraint];
  return constraint;
}

-(void)wps_centerInView:(UIView *)superview
{
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superview attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
}

-(void)wps_centerInContainerOnAxis:(NSLayoutAttribute)axis
{
    NSParameterAssert(axis == NSLayoutAttributeCenterX || axis == NSLayoutAttributeCenterY);
    
    UIView *superview = [self superview];
    NSParameterAssert(superview);
    [superview addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:axis relatedBy:NSLayoutRelationEqual toItem:superview attribute:axis multiplier:1.0 constant:0.0]];
}

#pragma mark - View Snapshot

- (UIImage *)wps_imageSnapshot
{
  UIGraphicsBeginImageContextWithOptions([self bounds].size, YES, 0.0f);
  [[self layer] renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

@end
