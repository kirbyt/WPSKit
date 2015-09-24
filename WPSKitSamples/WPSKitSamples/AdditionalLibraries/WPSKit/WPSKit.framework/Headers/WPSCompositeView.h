//
// WPSCompositeView.h
//
// Created by Kirby Turner.
// Copyright 2014 White Peak Software. All rights reserved.
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

/**
 Base class for creating a composite view class.
 
 A composite view is a view consisting of one or more UI elements representing a portion of the screen.
 */
@interface WPSCompositeView : UIView

/**
 Creates an instance of the view and adds it to the provided `superview`.
 
 @param superview The `superview` that will contain this view.
 @return An instance of the view added to the `superview`.
 */
+ (instancetype)addToSuperview:(UIView *)superview;

/**
 This method is responsible for loading the view. Each subclass must override this method.
 
 Do not call `[super loadView]` in your composite view subclass.
 
 You use `loadView` to create and add each UI element that is used to make up the composite view. How you load the view is up to you, though in most cases you will create the UI elements via code. More complex composite views can be created using a xib file.
 */
- (void)loadView;

@end
