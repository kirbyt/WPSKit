//
// WPSScrollViewController.m
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

#import "WPSScrollViewController.h"

@interface WPSScrollViewController () <UIScrollViewDelegate>
@property (nonatomic, strong, readwrite) UIScrollView *scrollView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *pageItemCache;
@property (nonatomic, strong) NSMutableSet *reusablePageItems;
@property (nonatomic, assign) Class registeredPageItemClass;
@end

@implementation WPSScrollViewController

- (void)loadView
{
  UIScrollView *scrollView = [[UIScrollView alloc] init];
  [scrollView setTranslatesAutoresizingMaskIntoConstraints:YES];
  [scrollView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
  [scrollView setDelegate:self];
  [scrollView setBackgroundColor:[UIColor clearColor]];
  [scrollView setPagingEnabled:YES];
  [scrollView setShowsVerticalScrollIndicator:NO];
  [scrollView setShowsHorizontalScrollIndicator:NO];
  [scrollView setAutoresizesSubviews:YES];
  [self setScrollView:scrollView];
  
  [self setView:scrollView];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self setScrollViewContentSize];
  [self scrollToPageAtIndex:[self currentPage] animated:NO];
}

- (void)scrollToPageAtIndex:(NSUInteger)index animated:(BOOL)animated
{
  [self setCurrentPage:index];
  [self _scrollToIndex:index animated:animated];
}

- (void)reloadData
{
  [self setPageItemCache:nil];
  [self setScrollViewContentSize];
}

- (void)registerPageItemClass:(Class)pageItemClass
{
  [self setRegisteredPageItemClass:pageItemClass];
}

- (void)setPageCount:(NSUInteger)pageCount
{
  if (_pageCount != pageCount) {
    _pageCount = pageCount;
    [self reloadData];
  }
}

- (id)dequeueReusablePageItem
{
  id pageItem = [[self reusablePageItems] anyObject];
  if (pageItem != nil) {
    [[self reusablePageItems] removeObject:pageItem];
  }
  return pageItem;
}

- (NSMutableSet *)reusablePageItems
{
  if (_reusablePageItems == nil) {
    _reusablePageItems = [NSMutableSet set];
  }
  return _reusablePageItems;
}

#pragma mark - Scrollview Setup

- (NSUInteger)adjustedPageCount
{
  NSUInteger pageCount = [self pageCount];
  if ([self infiniteScrollingEnabled]) {
    pageCount += 2; // Add pages to the fron and end for infinite scrolling.
  }
  return pageCount;
}

- (NSMutableArray *)pageItemCache
{
  if (_pageItemCache == nil) {
    NSUInteger pageCount = [self adjustedPageCount];
    _pageItemCache = [NSMutableArray arrayWithCapacity:pageCount];
    for (NSUInteger index = 0; index < pageCount; index++) {
      [_pageItemCache addObject:[NSNull null]];
    }
  }
  return _pageItemCache;
}

- (void)_scrollToIndex:(NSUInteger)index animated:(BOOL)animated
{
  UIScrollView *scrollView = [self scrollView];
  CGRect bounds = [scrollView bounds];
  bounds.origin.x = bounds.size.width * index;
  bounds.origin.y = 0;
  [scrollView scrollRectToVisible:bounds animated:animated];
}

- (void)setScrollViewContentSize
{
  UIScrollView *scrollView = [self scrollView];
  CGSize scrollViewSize = [scrollView bounds].size;
  CGSize size = CGSizeMake(scrollViewSize.width * [self adjustedPageCount], scrollViewSize.height / 2);   // Cut in half to prevent horizontal scrolling.
  [scrollView setContentSize:size];
}

#pragma mark - Frame calculations

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
  CGRect bounds = [[self scrollView] bounds];
  CGRect pageFrame = bounds;
  pageFrame.size.width -= (2 * [self pagePadding]);
  pageFrame.origin.x = (bounds.size.width * index) + [self pagePadding];
  return pageFrame;
}

#pragma mark - Page management

- (UIView *)viewFromPageItem:(id)pageItem
{
  UIView *pageView = nil;
  if ([pageItem isKindOfClass:[UIView class]]) {
    pageView = pageView;
  } else if ([pageItem respondsToSelector:@selector(view)]) {
    pageView = [pageItem view];
  }
  NSAssert(pageView, @"Invalid page item type. It must be a UIView or respond to the view selector.");

  return pageView;
}

- (void)loadPage:(NSInteger)index
{
  if (index < 0 || index >= (NSInteger)[self adjustedPageCount]) {
    return;
  }
  
  NSMutableArray *pageItemCache = [self pageItemCache];
  id currentPageView = [pageItemCache objectAtIndex:(NSUInteger)index];
  if ([currentPageView isKindOfClass:[NSNull class]]) {
    
    NSUInteger pageCount = [self adjustedPageCount];
    NSUInteger dataSourceIndex = (NSUInteger)index;
    if ([self infiniteScrollingEnabled]) {
      if (index == 0) {
        dataSourceIndex = pageCount - 3;
      } else if ((NSUInteger)index == pageCount - 1) {
        dataSourceIndex = 0;
      } else {
        dataSourceIndex = (NSUInteger)index - 1;
      }
    }
    
    id pageItem = [self dequeueReusablePageItem];
    if (pageItem == nil) {
      pageItem = [[[self registeredPageItemClass] alloc] init];
    }
    
    if (self.configurePageItem) {
      CGRect frame = [self frameForPageAtIndex:(NSUInteger)index];
      self.configurePageItem(pageItem, dataSourceIndex, frame);

      UIView *pageView = [self viewFromPageItem:pageItem];
      UIScrollView *scrollView = [self scrollView];
      [scrollView addSubview:pageView];
      [pageItemCache replaceObjectAtIndex:(NSUInteger)index withObject:pageItem];
    }
  }
}

- (void)unloadPage:(NSInteger)index
{
  if (index < 0 || index >= (NSInteger)[self adjustedPageCount]) {
    return;
  }
  
  NSMutableArray *pageItemCache = [self pageItemCache];
  id pageItem = [pageItemCache objectAtIndex:(NSUInteger)index];
  if ([pageItem isKindOfClass:[NSNull class]] == NO) {
    UIView *pageView = [self viewFromPageItem:pageItem];
    [pageView removeFromSuperview];
    [pageItemCache replaceObjectAtIndex:(NSUInteger)index withObject:[NSNull null]];
    [[self reusablePageItems] addObject:pageItem];
  }
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
  _currentPage = currentPage;
  
  [self loadPage:(NSInteger)currentPage];
  [self loadPage:(NSInteger)currentPage + 1];
  [self loadPage:(NSInteger)currentPage - 1];
  [self unloadPage:(NSInteger)currentPage + 2];
  [self unloadPage:(NSInteger)currentPage - 2];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if ([scrollView isScrollEnabled]) {
    CGFloat pageWidth = scrollView.bounds.size.width;
    CGFloat fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = (NSInteger)floor(fractionalPage);
    if (page != (NSInteger)[self currentPage]) {
      [self setCurrentPage:(NSUInteger)page];
    }
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  if ([self infiniteScrollingEnabled] == NO) {
    return;
  }
  
  CGFloat pageWidth = scrollView.bounds.size.width;
  CGFloat fractionalPage = scrollView.contentOffset.x / pageWidth;
  NSUInteger page = (NSUInteger)floor(fractionalPage);
  NSUInteger pageCount = [self adjustedPageCount];
  if (page == (pageCount - 1)) {
    [self _scrollToIndex:1 animated:NO];
  } else if (page == 0) {
    [self _scrollToIndex:(pageCount - 2) animated:NO];
  }
}

@end
