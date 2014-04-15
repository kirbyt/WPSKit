//
// UITextField+WPSKit.m
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

#import "UITextField+WPSKit.h"
#import <objc/runtime.h>

#pragma mark - WPSTextFieldInternalDelegate Class

@interface WPSTextFieldInternalDelegate : NSObject <UITextFieldDelegate>
@property (nonatomic, copy) BOOL (^shouldBeginEditingBlock)(UITextField *textField);
@property (nonatomic, copy) void (^didBeginEditingBlock)(UITextField *textField);
@property (nonatomic, copy) BOOL (^shouldEndEditingBlock)(UITextField *textField);
@property (nonatomic, copy) void (^didEndEditingBlock)(UITextField *textField);
@property (nonatomic, copy) BOOL (^shouldChangeCharactersInRangeBlock)(UITextField *textField, NSRange range, NSString *replacementString);
@property (nonatomic, copy) BOOL (^shouldClearBlock)(UITextField *textField);
@property (nonatomic, copy) BOOL (^shouldReturnBlock)(UITextField *textField);
@property (nonatomic, copy) void (^didChangeBlock)(UITextField *textField);
@end

@implementation WPSTextFieldInternalDelegate

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  BOOL shouldBeginEditing = YES;
  if (self.shouldBeginEditingBlock) {
    shouldBeginEditing = self.shouldBeginEditingBlock(textField);
  }
  return shouldBeginEditing;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  if (self.didBeginEditingBlock) {
    self.didBeginEditingBlock(textField);
  }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  BOOL shouldEndEditing = YES;
  if (self.shouldEndEditingBlock) {
    shouldEndEditing = self.shouldEndEditingBlock(textField);
  }
  return shouldEndEditing;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  if (self.didEndEditingBlock) {
    self.didEndEditingBlock(textField);
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  BOOL shouldChangeCharacters = YES;
  if (self.shouldChangeCharactersInRangeBlock) {
    shouldChangeCharacters = self.shouldChangeCharactersInRangeBlock(textField, range, string);
  }
  return shouldChangeCharacters;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
  BOOL shouldClear = YES;
  if (self.shouldClearBlock) {
    shouldClear = self.shouldClearBlock(textField);
  }
  return shouldClear;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  BOOL shouldReturn = YES;
  if (self.shouldReturnBlock) {
    shouldReturn = self.shouldReturnBlock(textField);
  }
  return shouldReturn;
}

#pragma mark - UITextField Action and Notification Handlers

- (void)textFieldDidChange:(id)sender
{
  if (self.didChangeBlock) {
    self.didChangeBlock(sender);
  }
}

@end

#pragma mark - UITextField (WPSKit) Category

@implementation UITextField (WPSKit)

static const void *WPSTextFieldInternalDelegateKey = &WPSTextFieldInternalDelegateKey;

- (WPSTextFieldInternalDelegate *)wps_internalDelegate
{
  id delegate = [self delegate];
  if (delegate == nil) {
    WPSTextFieldInternalDelegate *internalDelegate = [[WPSTextFieldInternalDelegate alloc] init];
    objc_setAssociatedObject(self, WPSTextFieldInternalDelegateKey, internalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setDelegate:internalDelegate];
    delegate = internalDelegate;
  }
  
  if ([delegate isKindOfClass:[WPSTextFieldInternalDelegate class]] == NO) {
    delegate = nil;
  }
  return delegate;
}

- (void)wps_setShouldBeginEditing:(BOOL (^)(UITextField *textField))block
{
  WPSTextFieldInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldBeginEditingBlock:block];
}

- (void)wps_setDidBeginEditing:(void (^)(UITextField *textField))block
{
  WPSTextFieldInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setDidBeginEditingBlock:block];
}

- (void)wps_setShouldEndEditing:(BOOL (^)(UITextField *textField))block
{
  WPSTextFieldInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldEndEditingBlock:block];
}

- (void)wps_setDidEndEditing:(void (^)(UITextField *textField))block
{
  WPSTextFieldInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setDidEndEditingBlock:block];
}

- (void)wps_setShouldChangeCharactersInRange:(BOOL (^)(UITextField *textField, NSRange range, NSString *replacementString))block
{
  WPSTextFieldInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldChangeCharactersInRangeBlock:block];
}

- (void)wps_setShouldClear:(BOOL (^)(UITextField *textField))block
{
  WPSTextFieldInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldClearBlock:block];
}

- (void)wps_setShouldReturn:(BOOL (^)(UITextField *textField))block
{
  WPSTextFieldInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldReturnBlock:block];
}

- (void)wps_setDidChange:(void (^)(UITextField *textField))block
{
  WPSTextFieldInternalDelegate *internalDelegate = [self wps_internalDelegate];
  if (internalDelegate) {
    [internalDelegate setDidChangeBlock:block];
    [self addTarget:internalDelegate action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  }
}

@end
