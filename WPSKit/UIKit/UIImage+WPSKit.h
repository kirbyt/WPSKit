//
// UIImage+WPSKit.h
//
// Created by Kirby Turner.
// Copyright 2011-2014 White Peak Software. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>

@interface UIImage (WPSKit)

/**
 Returns the suggested image size with the specified width. The size returned maintains the image aspect ratio.
 
 @param width The width of the suggested size.
 */
- (CGSize)wps_suggestedSizeWithWidth:(CGFloat)width;

/**
 Returns the suggested image size with the specified height. The size returned maintains the image aspect ratio.

 @param height The height of the suggested size.
 */
- (CGSize)wps_suggestedSizeWithHeight:(CGFloat)height;

/**
 Returns the suggested image size with max dimenson. The size returned maintains the image aspect ratio.
 
 The longest of the two, width or height, will equal the specified dimension based on the actual image size.
 
 @param dimension The maximum dimension, either width or height.
 */
- (CGSize)wps_suggestedSizeWithMaxDimension:(CGFloat)dimension;

/**
 Scales the image to the specified size.
 
 @param newSize New image size.
 */
- (UIImage *)wps_scaleToSize:(CGSize)newSize;

/**
 Scales the image to the maximum dimension, width or height, while maintaining the image aspect ratio.
 
 @param newSize Maximum dimension, either width or height.
 */
- (UIImage *)wps_scaleAspectToMaxSize:(CGFloat)newSize;

/**
 Scales the image to fill the size. Some portion of the image may be clipped to fill the image's bounds.
 
 @param newSize New image size.
 */
- (UIImage *)wps_scaleAspectFillToSize:(CGSize)newSize;

/**
 Scales the image to fit the size by maintaining the aspect ratio. Any remaining area of the image's bounds is transparent.

 @param newSize New image size.
 */
- (UIImage *)wps_scaleAspectFitToSize:(CGSize)newSize;

/**
 Crops an image to the specified rect.
 
 @param cropRect Rect size of the cropped image.
 */
- (UIImage *)wps_cropToRect:(CGRect)cropRect;

/**
 Scales the image to the specified size, cropping the image if needed.

 The cropped image will contain the inner most parts of the original image.

 @param newSize Size of the new image.
 */
- (UIImage *)wps_scaleAndCropToSize:(CGSize)newSize;

@end
