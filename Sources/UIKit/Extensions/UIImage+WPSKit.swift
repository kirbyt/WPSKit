//
// UIImage+WPSKit.swift
//
// Created by Kirby Turner.
// Copyright 2016 White Peak Software. All rights reserved.
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

import UIKit

extension UIImage {
  
  // -------------------------------------------------------------------
  // MARK: - Sizes
  // -------------------------------------------------------------------
  
  /**
   Returns the suggested image size with the specified width. The size returned maintains the image aspect ratio.
   
   - parameter width: The width of the suggested size.
   */
  public func suggestedSizeForWidth(_ width: Float) -> CGSize {
    let size: CGSize = self.size
    let cgFloatWidth = CGFloat(width)
    var ratio: CGFloat
    if size.width > cgFloatWidth {
      ratio = cgFloatWidth / size.width
    } else {
      ratio = size.width / cgFloatWidth
    }
    
    let scaleToSize: CGSize = CGSize(width: ratio * size.width, height: ratio * size.height)
    return scaleToSize
  }
  
  /**
   Returns the suggested image size with the specified height. The size returned maintains the image aspect ratio.
   
   - parameter height: The height of the suggested size.
   */
  public func suggestedSizeForHeight(_ height: Float) -> CGSize {
    let size = self.size
    let ratio: CGFloat
    let cgFloatHeight = CGFloat(height)
    if (size.height > cgFloatHeight) {
      ratio = cgFloatHeight / size.height;
    } else {
      ratio = size.height / cgFloatHeight;
    }
    
    let scaleToSize: CGSize = CGSize(width: ratio * size.width, height: ratio * size.height)
    return scaleToSize
    
  }
  
  /**
   Returns the suggested image size with max dimenson. The size returned maintains the image aspect ratio.
   
   The longest of the two, width or height, will equal the specified dimension based on the actual image size.
   
   - parameter dimension: The maximum dimension, either width or height.
   */
  public func suggestedSizeForMaxDimension(_ dimension: Float) -> CGSize {
    var scaleToSize: CGSize
    let size: CGSize = self.size
    if (size.width > size.height) {
      scaleToSize = self.suggestedSizeForWidth(dimension)
    } else {
      scaleToSize = self.suggestedSizeForHeight(dimension)
    }
    return scaleToSize
  }
  
  // -------------------------------------------------------------------
  // MARK: - Scaling
  // -------------------------------------------------------------------
  
  /**
   Scales the image to the specified size.
   
   - parameter newSize: New image size.
   
   - returns A new `UIImage`.
   */
  public func scaleToSize(_ newSize: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(newSize, true, 1.0)
    let rect:CGRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral;
    self.draw(in: rect)
    let scaledImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return scaledImage
  }
  
  /**
   Scales the image to the maximum dimension, width or height, while maintaining the image aspect ratio.
   
   - parameter newSize: Maximum dimension, either width or height.

   - returns A new `UIImage`.
   */
  public func scaleAspectToMaxSize(_ newSize: Float) -> UIImage {
    let scaleToSize: CGSize = self.suggestedSizeForMaxDimension(newSize)
    return self.scaleToSize(scaleToSize)
  }
  
  /**
   Scales the image to fill the size. Some portion of the image may be clipped to fill the image's bounds.
   
   - parameter newSize: New image size.

   - returns A new `UIImage`.
   */
  public func scaleAspectFillToSize(_ newSize: CGSize) -> UIImage {
    let imageSize: CGSize = self.size
    let horizontalRatio: CGFloat = newSize.width / imageSize.width
    let verticalRatio: CGFloat = newSize.height / imageSize.height
    let ratio: CGFloat = max(horizontalRatio, verticalRatio)
    
    let scaleToSize: CGSize = CGSize(width: imageSize.width * ratio, height: imageSize.height * ratio)
    return self.scaleToSize(scaleToSize)
    
  }
  
  /**
   Scales the image to fit the size by maintaining the aspect ratio. Any remaining area of the image's bounds is transparent.
   
   - parameter newSize: New image size.

   - returns A new `UIImage`.
   */
  public func scaleAspectFitToSize(_ newSize: CGSize) -> UIImage {
    let imageSize: CGSize = self.size
    let horizontalRatio: CGFloat = newSize.width / imageSize.width
    let verticalRatio: CGFloat = newSize.height / imageSize.height
    let ratio: CGFloat = min(horizontalRatio, verticalRatio)
    
    let scaleToSize:CGSize = CGSize(width: imageSize.width * ratio, height: imageSize.height * ratio)
    return self.scaleToSize(scaleToSize)
  }
  
  // -------------------------------------------------------------------
  // MARK: - Cropping
  // -------------------------------------------------------------------

  /**
   Crops an image to the specified rect.
   
   - parameter cropRect: Rect size of the cropped image.

   - returns A new `UIImage`.
   */
  public func cropToRect(_ cropRect: CGRect) -> UIImage {
    var croppedImage: UIImage = self
    let cropRectIntegral: CGRect = cropRect.integral
    if let croppedImageRef: CGImage = self.cgImage?.cropping(to: cropRectIntegral) {
      croppedImage = UIImage(cgImage: croppedImageRef)
    }
    
    return croppedImage
  }
  
  /**
   Scales the image to the specified size, cropping the image if needed.
   The cropped image will contain the inner most parts of the original image.
   
   - parameter newSize: Size of the new image.
   
   - returns A new `UIImage`.
   */
  public func scaleAndCropToSize(_ newSize: CGSize) -> UIImage {
    let scaledImage: UIImage = self.scaleAspectFillToSize(newSize)
    
    // Crop the image to the requested new size maintaining
    // the inner most parts of the image.
    let imageSize: CGSize = scaledImage.size
    #if CGFLOAT_IS_DOUBLE
      let offsetX: CGFloat = round((imageSize.width / 2.0) - (newSize.width / 2.0));
      let offsetY: CGFloat = round((imageSize.height / 2.0) - (newSize.height / 2.0));
    #else
      let offsetX: CGFloat = CGFloat(roundf((Float(imageSize.width) / 2.0) - (Float(newSize.width) / 2.0)))
      let offsetY: CGFloat = CGFloat(roundf((Float(imageSize.height) / 2.0) - (Float(newSize.height) / 2.0)))
    #endif
  
    let cropRect: CGRect = CGRect(x: offsetX, y: offsetY, width: newSize.width, height: newSize.height);
    let croppedImage: UIImage = scaledImage.cropToRect(cropRect)
    return croppedImage
  }
  
  // -------------------------------------------------------------------
  // MARK: - Square
  // -------------------------------------------------------------------
  
  /**
   Creates a square image cropping as needed.
   
   The cropped image will contain the inner most parts of the original image.
   
   The new image will have a size equal to the minimum width or height of the original image.
   
   - returns A new `UIImage`.
   */
  public func squareImage() -> UIImage {
    let imageSize: CGSize = self.size
    let dimension: Float  = min(Float(imageSize.width), Float(imageSize.height));
    return self.squareImageWithDimension(dimension)
  }
  
  /**
   Create a square image with the provided dimension cropping as needed.
   
   The cropped image will contain the inner most parts of the original image.
   
   - parameter dimension: The dimension of the new image.
   
   - returns A new `UIImage`.
   */
  public func squareImageWithDimension(_ dimension: Float) -> UIImage {
    let imageSize: CGSize = self.size
    #if CGFLOAT_IS_DOUBLE
      let offsetX: CGFloat = round((imageSize.width / 2.0) - (CGFloat(dimension) / 2.0));
      let offsetY: CGFloat = round((imageSize.height / 2.0) - (CGFloat(dimension) / 2.0));
    #else
      let offsetX: CGFloat = CGFloat(roundf((Float(imageSize.width) / 2.0) - (dimension / 2.0)))
      let offsetY: CGFloat = CGFloat(roundf((Float(imageSize.height) / 2.0) - (dimension / 2.0)))
    #endif
    
    let cropRect: CGRect = CGRect(x: offsetX, y: offsetY, width: CGFloat(dimension), height: CGFloat(dimension))
    let squareImage: UIImage = self.cropToRect(cropRect)
    return squareImage
  }
  
  // -------------------------------------------------------------------
  // MARK: - Rounded
  // -------------------------------------------------------------------
  
  /**
   Creates a round image.
   
   - return A new `UIImage`.
   */
  public func roundedImage() -> UIImage {
    let squareImage: UIImage = self.squareImage()
    let imageSize: CGSize = squareImage.size;
    return squareImage.roundedImageWithCornerRadius(Float(imageSize.width / 2.0))
  }
  
  /**
   Creates a round image with the provided diameter.
   
   - parameter diameter: The diameter of the round image.

   - return A new `UIImage`.
   */
  public func roundedImageWithDiameter(_ diameter: Float) -> UIImage {
    let squareImage: UIImage = self.squareImage()
    let scaledImage: UIImage = squareImage.scaleToSize(CGSize(width: CGFloat(diameter), height: CGFloat(diameter)))
    let imageSize: CGSize = scaledImage.size
    return scaledImage.roundedImageWithCornerRadius(Float(imageSize.width/2.0))
  }
  
  /**
   Creates a new `UIImage` with rounded corners using the provided corner radius.
   
   - parameter cornerRadius: The radius to use when drawing rounded corners.
   
   - return A new `UIImage`.
   */
  public func roundedImageWithCornerRadius(_ cornerRadius: Float) -> UIImage {
    let imageSize: CGSize = self.size
    
    let imageLayer: CALayer = CALayer()
    imageLayer.frame = CGRect(x: 0.0, y: 0.0, width: imageSize.width, height: imageSize.height)
    imageLayer.contents = self.cgImage
    imageLayer.masksToBounds = true
    imageLayer.cornerRadius = CGFloat(cornerRadius)
    
    guard let context = UIGraphicsGetCurrentContext() else {
      return self;
    }
    
    UIGraphicsBeginImageContext(imageSize);
    imageLayer.render(in: context)
    let roundedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return roundedImage
  }
  
  // -------------------------------------------------------------------
  // MARK: - Color
  // -------------------------------------------------------------------
  
  /**
   Returns an image of the specified color.
   
   The image returned is 1x1, but can be stretched as needed by the caller.
   
   - parameter color: The color drawn in the image.
   
   - returns `UIImage` of the color.
   */
  public class func imageFromColor(_ color: UIColor) -> UIImage {
    return self.imageFromColor(color, size: CGSize(width: 1.0, height: 1.0))
  
  }
  
  /**
   Returns an image of the specified color.
   
   - parameter color: The color drawn in the image.
   - parameter size:  Size of the image.
   
   - returns `UIImage` of the color.
   */
  public class func imageFromColor(_ color: UIColor, size: CGSize) -> UIImage {
    let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
    UIGraphicsBeginImageContext(rect.size);
    guard let context: CGContext = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return UIImage()
    }
    context.setFillColor(color.cgColor)
    context.fill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
  
  /**
   Returns an image masked with the specified color.
   
   - parameter name:  The image name.
   - parameter color: Mask color.
   
   - returns `UIImage` masked with the specified color.
   */
  public class func imageNamed(_ name: String, maskColor: UIColor) -> UIImage? {
    guard let image: UIImage = UIImage(named: name) else {
      return nil
    }
    
    return image.imageWithMaskColor(maskColor)
  }
  
  /**
   Returns an image masked with the specified color.
   
   - parameter color: Mask color.
   
   - returns `UIImage` masked with the specified color.
   */
  public func imageWithMaskColor(_ color: UIColor) -> UIImage {
    let rect: CGRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, self.scale)
    guard let c: CGContext = UIGraphicsGetCurrentContext() else {
      UIGraphicsEndImageContext()
      return UIImage()
    }
    
    self.draw(in: rect)
    c.setFillColor(color.cgColor)
    c.setBlendMode(.sourceAtop)
    c.fill(rect)
    let maskedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return maskedImage
  }

}
