//
//  WPSPageControl.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 6/13/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import "WPSPageControl.h"

#define kWFMDotDiameter 7.0
#define kWFMDotSpacer 7.0

@interface WPSPageControl ()

@end

@implementation WPSPageControl

- (void)commonInit
{
   CGRect frame = [self frame];
   frame.size.height = 36;
   [self setFrame:frame];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:0 multiplier:0 constant:36.0f]];
    
   [self setBackgroundColor:[UIColor clearColor]];
}

- (id)init
{
   self = [super init];
   if (self) {
      [self commonInit];
   }
   return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
   self = [super initWithCoder:aDecoder];
   if (self) {
      [self commonInit];
   }
   return self;
}

- (id)initWithFrame:(CGRect)frame
{
   if ((self = [super initWithFrame:frame]))
   {
      [self commonInit];
   }
   return self;
}

- (void)setCurrentPage:(NSInteger)page
{
   _currentPage = MIN(MAX(0, page), _numberOfPages-1);
   [self setNeedsDisplay];
}

- (void)setNumberOfPages:(NSInteger)pages
{
   _numberOfPages = MAX(0, pages);
   _currentPage = MIN(MAX(0, _currentPage), _numberOfPages-1);
   [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
   CGContextRef context = UIGraphicsGetCurrentContext();
   CGContextSetAllowsAntialiasing(context, true);
   
   CGSize dotSize = [[self currentPageDotImage] size];

   NSInteger numberOfPages = [self numberOfPages];
   NSInteger currentPage = [self currentPage];
   
   CGRect currentBounds = [self bounds];
   CGFloat dotsWidth = numberOfPages * dotSize.width + MAX(0, numberOfPages - 1) * kWFMDotSpacer;
   CGFloat x = CGRectGetMidX(currentBounds) - dotsWidth / 2;
   CGFloat y = CGRectGetMidY(currentBounds) - dotSize.height / 2;
   for (int i=0; i < numberOfPages; i++)
   {
      CGRect circleRect = CGRectMake(x, y, dotSize.width, dotSize.height);
      if (i == currentPage)
      {
         [[self currentPageDotImage] drawInRect:circleRect];
      }
      else
      {
         [[self otherPageDotImage] drawInRect:circleRect];
      }
      x += dotSize.width + kWFMDotSpacer;
   }
}

@end
