//
//  NSDateTests.m
//  WPSKitTests
//
//  Created by Kirby Turner on 5/22/15.
//  Copyright (c) 2015 White Peak Software Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSDate+WPSKit.h"

@interface NSDateTests : XCTestCase

@end

@implementation NSDateTests

- (NSDateComponents *)dateComponentsFromDate:(NSDate *)date
{
  NSCalendarUnit components = NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond;
  NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *dateComponents = [calendar components:components fromDate:date];
  return dateComponents;
}

- (void)testTodayAtMidnight
{
  NSDate *date = [NSDate wps_todayAtMidnight];
  XCTAssertNotNil(date, @"Unassigned NSDate instance.");

  NSDateComponents *dateComponents = [self dateComponentsFromDate:date];
  XCTAssertEqual([dateComponents hour], 0);
  XCTAssertEqual([dateComponents minute], 0);
  XCTAssertEqual([dateComponents second], 0);
}

- (void)testDateAtMidnight
{
  NSDate *date = [[NSDate date] wps_dateAtMidnight];
  XCTAssertNotNil(date, @"Unassigned NSDate instance.");

  NSDateComponents *dateComponents = [self dateComponentsFromDate:date];
  XCTAssertEqual([dateComponents hour], 0);
  XCTAssertEqual([dateComponents minute], 0);
  XCTAssertEqual([dateComponents second], 0);
}

- (void)testDateAtHourMinuteDay
{
  NSDate *date = [[NSDate date] wps_dateWithHour:13 minute:12 second:11];
  XCTAssertNotNil(date, @"Unassigned NSDate instance.");
  
  NSDateComponents *dateComponents = [self dateComponentsFromDate:date];
  XCTAssertEqual([dateComponents hour], 13);
  XCTAssertEqual([dateComponents minute], 12);
  XCTAssertEqual([dateComponents second], 11);
}

@end
