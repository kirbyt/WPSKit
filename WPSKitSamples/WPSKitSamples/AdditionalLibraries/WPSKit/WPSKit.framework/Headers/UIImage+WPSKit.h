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

#pragma mark - Sizes
/// -----------------
/// @name Sizes
/// -----------------

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

#pragma mark - Scaling
/// -----------------
/// @name Scaling
/// -----------------

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

#pragma mark - Cropping
/// -----------------
/// @name Cropping
/// -----------------

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

#pragma mark - Square
/// -----------------
/// @name Square
/// -----------------

/**
 Creates a square image cropping as needed.
 
 The cropped image will contain the inner most parts of the original image.
 
 The new image will have a size equal to the minimum width or height of the original image.
 
 @return Returns a new `UIImage`.
 */
- (UIImage *)wps_squareImage;

/**
 Create a square image with the provided dimension cropping as needed.
 
 The cropped image will contain the inner most parts of the original image.
 
 @param dimension The dimension of the new image.
 @return Returns a new `UIImage`.
 */
- (UIImage *)wps_squareImageWithDimension:(CGFloat)dimension;

#pragma mark - Rounded
/// -----------------
/// @name Rounded
/// -----------------

/**
 Creates a round image.
 
 @return Returns a new `UIImage`.
 */
- (UIImage *)wps_roundedImage;

/**
 Creates a round image with the provided diameter.
 
 @param diameter The diameter of the round image.
 @return Returns a new `UIImage`.
 */
- (UIImage *)wps_roundedImageWithDiameter:(CGFloat)diameter;

/**
 Creates a new `UIImage` with rounded corners using the provided corner radius.
 
 @param cornerRadius The radius to use when drawing rounded corners.
 @return Returns a new `UIImage`.
 */
- (UIImage *)wps_roundedImageWithCornerRadius:(CGFloat)cornerRadius;

#pragma mark - Color
/// -----------------
/// @name Color
/// -----------------

/**
 Returns an image of the specified color.
 
 The image returned is 1x1, but can be stretched as needed by the caller.
 
 @param color The color drawn in the image.
 @return `UIImage` of the color.
 */
+ (UIImage *)wps_imageFromColor:(UIColor *)color;

/**
 Returns an image of the specified color.
 
 @param color The color drawn in the image.
 @param size Size of the image.
 @return `UIImage` of the color.
 */
+ (UIImage *)wps_imageFromColor:(UIColor *)color size:(CGSize)size;

/**
 Returns an image masked with the specified color.

 @param name The image name.
 @param color Mask color.
 @param `UIImage` masked with the specified color.
 */
+ (UIImage *)wps_imageNamed:(NSString *)name withMaskColor:(UIColor *)color;

/**
 Returns an image masked with the specified color.
 
 @param color Mask color.
 @param `UIImage` masked with the specified color.
 */
- (UIImage *)wps_imageWithMaskColor:(UIColor *)color;

@end
