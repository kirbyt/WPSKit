//
// WPSKit
// NSDate+WPSKit.m
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

#import "NSDate+WPSKit.h"

@implementation NSDate (WPSKit)

+ (NSDate *)wps_todayAtMidnight
{
  return [[NSDate date] wps_dateAtMidnight];
}

- (NSDate *)wps_dateAtMidnight
{
  NSDate *dateAtMidnight = nil;
  
  NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
  if ([calendar respondsToSelector:@selector(startOfDayForDate:)]) {
    // iOS 8 and above.
    dateAtMidnight = [calendar startOfDayForDate:self];
    
  } else {
    dateAtMidnight = [self wps_dateWithHour:0 minute:0 second:0];
  }
  
  return dateAtMidnight;
}

- (NSDate *)wps_dateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
  NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
  NSDateComponents *dateComponents = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
  [dateComponents setHour:hour];
  [dateComponents setMinute:minute];
  [dateComponents setSecond:second];
  
  return [calendar dateFromComponents:dateComponents];
}

@end
