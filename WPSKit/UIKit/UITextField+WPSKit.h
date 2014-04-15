//
// UITextField+WPSKit.h
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
 This category adds methods to the UIKit's `UITextField` class. The methods in this category adds block support to `UITextField`.
 */
@interface UITextField (WPSKit)

/**
 Asks the block if editing should begin in the specified text field.
 
 @param block The block to be executed inplace of `UITextFieldDelegate`'s `-textFieldShouldBeginEditing:`. Return `YES` if an editing session should be initiated; otherwise, `NO` to disallow editing. The default return value is `YES`.
 */
- (void)wps_setShouldBeginEditing:(BOOL (^)(UITextField *textField))block;

/**
 Tells the block that editing began for the specified text field.
 
 @param block The block to be executed inplace of `UITextFieldDelegate`'s `-textFieldDidBeginEditing:`.
 */
- (void)wps_setDidBeginEditing:(void (^)(UITextField *textField))block;

/**
 Asks the block if editing should stop in the specified text field.

 @param block The block to be executed inplace of `UITextFieldDelegate`'s `-textFieldShouldEndEditing:`. Return `YES` if editing should stop; otherwise, `NO` if the editing session should continue. The default return value is `YES`.
*/
- (void)wps_setShouldEndEditing:(BOOL (^)(UITextField *textField))block;

/**
 Tells the block that editing stopped for the specified text field.

 @param block The block to be executed inplace of `UITextFieldDelegate`'s `-textFieldDidEndEditing:`.
 */
- (void)wps_setDidEndEditing:(void (^)(UITextField *textField))block;

/**
 Asks the block if the specified text should be changed.
 
 @param block The block to be executed inplace of `UITextFieldDelegate`'s `-textField:shouldChangeCharactersInRange:replacementString:`. Return `YES` if the specified text range should be replaced; otherwise, `NO` to keep the old text. The default return value is `YES`.
 */
- (void)wps_setShouldChangeCharactersInRange:(BOOL (^)(UITextField *textField, NSRange range, NSString *replacementString))block;

/**
 Asks the block if the text field’s current contents should be removed.
 
 @param block The block to be executed inplace of `UITextFieldDelegate`'s `-textFieldShouldClear:`. `YES` if the text field’s contents should be cleared; otherwise, `NO`.
 */
- (void)wps_setShouldClear:(BOOL (^)(UITextField *textField))block;

/**
 Asks the block if the text field should process the pressing of the return button.

 @param block The block to be executed inplace of `UITextFieldDelegate`'s `-textFieldShouldReturn:`. `YES` if the text field should implement its default behavior for the return button; otherwise, `NO`.
*/
- (void)wps_setShouldReturn:(BOOL (^)(UITextField *textField))block;

/**
 */
- (void)wps_setDidChange:(void (^)(UITextField *textField))block;

@end
