//
// WPSTableViewCell.h
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

#import <UIKit/UIKit.h>

@interface WPSTableViewCell : UITableViewCell

/**
 The cell identifier.
 
 This is the same as the class name.
 
 @return An `NSString` containing the cell identifier.
 */
+ (NSString *)cellIdentifier;

/*
 I think it might be time to remove these old methods.
 */
+ (id)cellForTableView:(UITableView *)tableView;
+ (id)cellForTableView:(UITableView *)tableView fromNib:(UINib *)nib;
+ (id)cellFromDefaultNibForTableView:(UITableView *)tableView;
- (id)initWithCellIdentifier:(NSString *)cellID;

/**
 Get a reference to the nib associated with this class.
 
 @return A reference to the `UINib` associated with this class.
 */
+ (UINib *)nib;

/**
 The nib's name.
 
 This is the same as the class name.
 
 @return An `NSString` representing the nib's name.
 */
+ (NSString *)nibName;

/**
 Register the class for use as a cell with the provided table view.
 
 @param tableView The table view that will use this cell class.
 */
+ (void)registerClassWithTableView:(UITableView *)tableView;

/**
 Register the nib for this class for use as a cell with the provided table view.
 
 @param tableView The table view that will use this cell class.
 */
+ (void)registerNibWithTableView:(UITableView *)tableView;

/**
 Override this method to display a custom detail disclosure button.
 */
- (void)setDetailDisclosureButtonImage:(UIImage *)detailDisclosureButtonImage detailDisclosureButtonHighlightedImage:(UIImage *)detailDisclosureButtonHighlightedImage;

@end
