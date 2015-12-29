//
// WPSKit
//
// Created by Kirby Turner.
// Copyright 2015 White Peak Software. All rights reserved.
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

//! Project version number for WPSKit.
FOUNDATION_EXPORT double WPSKitVersionNumber;

//! Project version string for WPSKit.
FOUNDATION_EXPORT const unsigned char WPSKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <WPSKit/PublicHeader.h>

#pragma mark - Core Data

#import <WPSKit/NSManagedObject+WPSKit.h>
#import <WPSKit/NSManagedObjectContext+WPSKit.h>
#import <WPSKit/WPSCoreDataStack.h>
#import <WPSKit/WPSFetchedResultsDelegate.h>
#import <WPSKit/WPSManagedObjectContextWatcher.h>

#pragma mark - Data Sources

#import <WPSKit/WPSDataSource.h>
#import <WPSKit/WPSArrayDataSource.h>
#import <WPSKit/WPSFetchedResultsDataSource.h>

#pragma mark - Core Location

#import <WPSKit/CLLocation+WPSKit.h>

#pragma mark - Foundation

#import <WPSKit/NSArray+WPSKit.h>
#import <WPSKit/NSData+WPSKit.h>
#import <WPSKit/NSDate+WPSKit.h>
#import <WPSKit/NSFileManager+WPSKit.h>
#import <WPSKit/NSNotificationCenter+WPSKit.h>
#import <WPSKit/NSNull+WPSKit.h>
#import <WPSKit/NSString+WPSKit.h>
#import <WPSKit/NSURL+WPSKit.h>
#import <WPSKit/WPSActivityTracker.h>
#import <WPSKit/WPSCache.h>
#import <WPSKit/WPSStopwatch.h>
#import <WPSKit/WPSWebError.h>
#import <WPSKit/WPSWebSession.h>

#pragma mark - MapKit
#import <WPSKit/MKMapView+WPSKit.h>

#pragma mark - UIKit

#import <WPSKit/UIApplication+WPSKit.h>
#import <WPSKit/UICollectionView+WPSKit.h>
#import <WPSKit/UIColor+WPSKit.h>
#import <WPSKit/UIDevice+WPSKit.h>
#import <WPSKit/UIFont+WPSKit.h>
#import <WPSKit/UIImage+WPSKit.h>
#import <WPSKit/UITextField+WPSKit.h>
#import <WPSKit/UITextView+WPSKit.h>
#import <WPSKit/UIView+WPSKit.h>
#import <WPSKit/UIViewController+WPSKit.h>
#import <WPSKit/WPSAlertController.h>
#import <WPSKit/WPSCollectionReusableView.h>
#import <WPSKit/WPSCollectionViewCell.h>
#import <WPSKit/WPSCompositeView.h>
#import <WPSKit/WPSFeedbackEmailController.h>
#import <WPSKit/WPSPageControl.h>
#import <WPSKit/WPSScrollViewController.h>
#import <WPSKit/WPSTableViewCell.h>
#import <WPSKit/WPSTextView.h>


#ifdef DEBUG
#define WPS_DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define WPS_ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]
#else
#define WPS_DLog(...) do { } while (0)
#ifndef NS_BLOCK_ASSERTIONS
#define NS_BLOCK_ASSERTIONS
#endif
#define WPS_ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#endif

#define WPS_Assert(condition, ...) do { if (!(condition)) { WPS_ALog(__VA_ARGS__); }} while(0)

