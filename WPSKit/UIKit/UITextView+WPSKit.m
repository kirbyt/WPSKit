//
// UITextView+WPSKit.m
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

#import "UITextView+WPSKit.h"
#import <objc/runtime.h>

#pragma mark - WPSTextViewInternalDelegate Class

@interface WPSTextViewInternalDelegate : NSObject <UITextViewDelegate>
@property (nonatomic, copy) BOOL (^shouldBeginEditingBlock)(UITextView *textView);
@property (nonatomic, copy) BOOL (^shouldEndEditingBlock)(UITextView *textView);
@property (nonatomic, copy) void (^didBeginEditingBlock)(UITextView *textView);
@property (nonatomic, copy) void (^didEndEditingBlock)(UITextView *textView);
@property (nonatomic, copy) BOOL (^shouldChangeTextInRangeBlock)(UITextView *textView, NSRange range, NSString *replacementText);
@property (nonatomic, copy) void (^didChangeBlock)(UITextView *textView);
@property (nonatomic, copy) void (^didChangeSelectionBlock)(UITextView *textView);
@property (nonatomic, copy) BOOL (^shouldInteractWithURLBlock)(UITextView *textView, NSURL *URL, NSRange characterRange);
@property (nonatomic, copy) BOOL (^shouldInteractWithTextAttachmentBlock)(UITextView *textView, NSTextAttachment *textAttachment, NSRange characterRange);
@end

@implementation WPSTextViewInternalDelegate

#pragma mark - UITextViewDelegate Methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
  BOOL shouldBeginEditing = YES;
  if (self.shouldBeginEditingBlock) {
    shouldBeginEditing = self.shouldBeginEditingBlock(textView);
  }
  return shouldBeginEditing;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
  BOOL shouldEndEditing = YES;
  if (self.shouldEndEditingBlock) {
    shouldEndEditing = self.shouldEndEditingBlock(textView);
  }
  return shouldEndEditing;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
  if (self.didBeginEditingBlock) {
    self.didBeginEditingBlock(textView);
  }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
  if (self.didEndEditingBlock) {
    self.didEndEditingBlock(textView);
  }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
  BOOL shouldChangeCharacters = YES;
  if (self.shouldChangeTextInRangeBlock) {
    shouldChangeCharacters = self.shouldChangeTextInRangeBlock(textView, range, text);
  }
  return shouldChangeCharacters;
}

- (void)textViewDidChange:(UITextView *)textView
{
  if (self.didChangeBlock) {
    self.didChangeBlock(textView);
  }
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
  if (self.didChangeSelectionBlock) {
    self.didChangeSelectionBlock(textView);
  }
  return;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
  BOOL shouldInteract = YES;
  if (self.shouldInteractWithURLBlock) {
    shouldInteract = self.shouldInteractWithURLBlock(textView, URL, characterRange);
  }
  return shouldInteract;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
  BOOL shouldInteract = YES;
  if (self.shouldInteractWithTextAttachmentBlock) {
    shouldInteract = self.shouldInteractWithTextAttachmentBlock(textView, textAttachment, characterRange);
  }
  return shouldInteract;
}

@end

#pragma mark - UITextView (WPSKit) Category

@implementation UITextView (WPSKit)

static const void *WPSTextViewInternalDelegateKey = &WPSTextViewInternalDelegateKey;

- (WPSTextViewInternalDelegate *)wps_internalDelegate
{
  id delegate = [self delegate];
  if (delegate == nil) {
    WPSTextViewInternalDelegate *internalDelegate = [[WPSTextViewInternalDelegate alloc] init];
    objc_setAssociatedObject(self, WPSTextViewInternalDelegateKey, internalDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setDelegate:internalDelegate];
    delegate = internalDelegate;
  }
  
  if ([delegate isKindOfClass:[WPSTextViewInternalDelegate class]] == NO) {
    delegate = nil;
  }
  return delegate;
}

- (void)wps_setShouldBeginEditing:(BOOL (^)(UITextView *textView))block
{
  WPSTextViewInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldBeginEditingBlock:block];
}

- (void)wps_setShouldEndEditing:(BOOL (^)(UITextView *textView))block
{
  WPSTextViewInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldEndEditingBlock:block];
}

- (void)wps_setDidBeginEditing:(void (^)(UITextView *textView))block
{
  WPSTextViewInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setDidBeginEditingBlock:block];
}

- (void)wps_setDidEndEditing:(void (^)(UITextView *textView))block
{
  WPSTextViewInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setDidEndEditingBlock:block];
}

- (void)wps_setShouldChangeTextInRange:(BOOL (^)(UITextView *textView, NSRange range, NSString *replacementText))block
{
  WPSTextViewInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldChangeTextInRangeBlock:block];
}

- (void)wps_setDidChange:(void (^)(UITextView *textView))block
{
  WPSTextViewInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setDidChangeBlock:block];
}

- (void)wps_setDidChangeSelection:(void (^)(UITextView *textView))block
{
  WPSTextViewInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setDidChangeSelectionBlock:block];
}

- (void)wps_setShouldInteractWithURL:(BOOL (^)(UITextView *textView, NSURL *URL, NSRange characterRange))block
{
  WPSTextViewInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldInteractWithURLBlock:block];
}

- (void)wps_setShouldInteractWithTextAttachment:(BOOL (^)(UITextView *textView, NSTextAttachment *textAttachment, NSRange characterRange))block
{
  WPSTextViewInternalDelegate *internalDelegate = [self wps_internalDelegate];
  [internalDelegate setShouldInteractWithTextAttachmentBlock:block];
}

@end
