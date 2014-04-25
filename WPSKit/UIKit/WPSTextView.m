//
// WPSTextView.m
//
// Created by Kirby Turner.
// Copyright 2011 White Peak Software. All rights reserved.
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

#import "WPSTextView.h"

@interface WPSTextView ()
@property (nonatomic, strong) UILabel *placeholder;
@end

@implementation WPSTextView

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)commonInit
{
  [self setPlaceholderText:@""];
  [self setPlaceholderColor:[UIColor lightGrayColor]];
  
  UILabel *placeholder = [[UILabel alloc] init];
  [placeholder setLineBreakMode:NSLineBreakByWordWrapping];
  [placeholder setNumberOfLines:0];
  [placeholder setBackgroundColor:[UIColor clearColor]];
  [placeholder setAlpha:0];
  [self addSubview:placeholder];
  [self sendSubviewToBack:placeholder];
  
  [self setPlaceholder:placeholder];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self commonInit];
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
  self = [super initWithFrame:frame];
  if (self) {
    [self commonInit];
  }
  return self;
}

- (void)textChanged:(NSNotification *)notification
{
  if ([[self placeholderText] length] == 0) {
    return;
  }
  
  if ([[self text] length] == 0) {
    [[self placeholder] setAlpha:1.0];
  } else {
    [[self placeholder] setAlpha:0.0];
  }
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
  _placeholderColor = placeholderColor;
  [self setPlaceholderStyle];
}

- (void)setPlaceholderText:(NSString *)placeholderText
{
  _placeholderText = placeholderText;
  [self setPlaceholderStyle];
}

- (void)setPlaceholderStyle
{
  UILabel *placeholder = [self placeholder];
  [placeholder setFont:[self font]];
  [placeholder setTextColor:[self placeholderColor]];
  [placeholder setText:[self placeholderText]];
}

- (void)drawRect:(CGRect)rect
{
  CGFloat alpha = 0.0f;
  if ([[self text] length] == 0 && [[self placeholderText] length] > 0) {
    alpha = 1.0f;
  }
  
  UILabel *placeholder = [self placeholder];
  if ([placeholder alpha] != alpha) {
    CGRect placeholderRect = [self placeholderRectForBounds:[self bounds]];
    [placeholder setFrame:placeholderRect];
    [placeholder sizeToFit];
    [placeholder setAlpha:alpha];
  }
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
  //
  // Created by Sam Soffes on 8/18/10.
  // From: https://github.com/soffes/SAMTextView
  //
	CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
  
	if ([self respondsToSelector:@selector(textContainer)]) {
		rect = UIEdgeInsetsInsetRect(rect, self.textContainerInset);
		CGFloat padding = self.textContainer.lineFragmentPadding;
		rect.origin.x += padding;
		rect.size.width -= padding * 2.0f;
	} else {
		if (self.contentInset.left == 0.0f) {
			rect.origin.x += 8.0f;
		}
		rect.origin.y += 8.0f;
	}
  
	return rect;
}

@end
