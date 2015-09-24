//
// UITextView+WPSKit.h
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
 This category adds methods to the UIKit's `UITextView` class. The methods in this category adds block support to `UITextView`.
 */
@interface UITextView (WPSKit)

/**
 Asks the block if editing should begin in the specified text view.
 
 @param block The block to be executed inplace of `UITextViewDelegate`'s `-textViewShouldBeginEditing:`. Return `YES` if an editing session should be initiated; otherwise, `NO` to disallow editing. The default return value is `YES`.
 */
- (void)wps_setShouldBeginEditing:(BOOL (^)(UITextView *textView))block;

/**
 Asks the block if editing should stop in the specified text view.
 
 @param block The block to be executed inplace of `UITextViewDelegate`'s `-textViewShouldEndEditing:`. Return `YES` if editing should stop; otherwise, `NO` if the editing session should continue. The default return value is `YES`.
 */
- (void)wps_setShouldEndEditing:(BOOL (^)(UITextView *textView))block;

/**
 Tells the block that editing began for the specified text view.
 
 @param block The block to be executed inplace of `UITextViewDelegate`'s `-textViewDidBeginEditing:`.
 */
- (void)wps_setDidBeginEditing:(void (^)(UITextView *textView))block;

/**
 Tells the block that editing stopped for the specified text view.
 
 @param block The block to be executed inplace of `UITextViewDelegate`'s `-textViewDidEndEditing:`.
 */
- (void)wps_setDidEndEditing:(void (^)(UITextView *textView))block;

/**
 Asks the block if the specified text should be changed.
 
 @param block The block to be executed inplace of `UITextViewDelegate`'s `-textView:shouldChangeTextInRange:replacementText:`. Return `YES` if the specified text range should be replaced; otherwise, `NO` to keep the old text. The default return value is `YES`.
 */
- (void)wps_setShouldChangeTextInRange:(BOOL (^)(UITextView *textView, NSRange range, NSString *replacementText))block;

/**
 Tells the block that the text or attributes in the specified text view were changed by the user.
 
 The text view calls this method in response to user-initiated changes to the text. This method is not called in response to programmatically initiated changes.
 
 @param block The block to be executed inplace of `UITextViewDelegate`'s `-textViewDidChange:`.
 */
- (void)wps_setDidChange:(void (^)(UITextView *textView))block;

/**
 Tells the block that the text selection changed in the specified text view.
 
 You can use the `selectedRange` property of the text view to get the new selection.

 @param block The block to be executed inplace of `UITextViewDelegate`'s `-textViewDidChangeSelection:`.
*/
- (void)wps_setDidChangeSelection:(void (^)(UITextView *textView))block;

/**
 Asks the block if the specified text view should allow user interaction with the given URL in the given range of text.
 
 @param block The block to be executed inplace of `UITextViewDelegate`'s `-textView:shouldInteractWithURL:inRange:`.
 */
- (void)wps_setShouldInteractWithURL:(BOOL (^)(UITextView *textView, NSURL *URL, NSRange characterRange))block;

/**
 Asks the block if the specified text view should allow user interaction with the provided text attachment in the given range of text.
 
 @param block The block to be executed inplace of `UITextViewDelegate`'s `-textView:shouldInteractWithTextAttachment:inRange:`.
 */
- (void)wps_setShouldInteractWithTextAttachment:(BOOL (^)(UITextView *textView, NSTextAttachment *textAttachment, NSRange characterRange))block;

@end
