//
//  CustomDetailDisclosureCell.m
//  WPSKitSamples
//
//  Created by Kirby Turner on 8/22/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import "CustomDetailDisclosureCell.h"

@implementation CustomDetailDisclosureCell

- (void)awakeFromNib
{
   [super awakeFromNib];
   
   UIImage *normal = [UIImage imageNamed:@"btn-detaildisclosure.png"];
   UIImage *highlighted = [UIImage imageNamed:@"btn-detaildisclosurepressed.png"];
#warning Fix Me
//   [self setDetailDisclosureButtonImage:normal detailDisclosureButtonHighlightedImage:highlighted];
}

@end
