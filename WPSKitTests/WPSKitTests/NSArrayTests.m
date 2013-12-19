//
//  NSArrayTests.m
//  WPSKitTests
//
//  Created by Kirby Turner on 3/5/13.
//  Copyright (c) 2013 White Peak Software Inc. All rights reserved.
//

#import "NSArrayTests.h"
#import "NSArray+WPSKit.h"

@implementation NSArrayTests

- (void)testFirstObject
{
   NSArray *array = nil;
   id value = [array wps_firstObject];
   STAssertNil(value, @"Expected nil object reference.");

   array = @[];
   value = [array wps_firstObject];
   STAssertNil(value, @"Expected nil object reference.");
   
   array = @[@"one", @"two"];
   value = [array wps_firstObject];
   STAssertNotNil(value, @"Unassigned object reference");
   STAssertTrue([value isEqualToString:@"one"], @"Unexpected object reference");
}

- (void)testSafeObjectAtIndex
{
  NSArray *array = nil;
  id value = [array wps_safeObjectAtIndex:0];
  STAssertNil(value, @"Expected nil object reference.");

  array = @[];
  value = [array wps_safeObjectAtIndex:0];
  STAssertNil(value, @"Expected nil object reference.");
  
  array = @[@"one", @"two"];
  value = [array wps_safeObjectAtIndex:0];
  STAssertNotNil(value, @"Unassigned object reference");
  STAssertTrue([value isEqualToString:@"one"], @"Unexpected object reference");
}

@end
