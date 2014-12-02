//
//  NSNotification_AQSEventTestTests.m
//  AQSEvent
//
//  Created by kaiinui on 2014/12/02.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

#import "AQSEvent.h"
#import "NSNotification+AQSEventTest.h"

@interface NSNotification_AQSEventTestTests : XCTestCase

@end

@implementation NSNotification_AQSEventTestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItComparesNotificationWithMeasurementEvents {
    NSNotification *notification = [NSNotification notificationWithName:kAQSEvent
                                                                 object:nil
                                                               userInfo:@{
                                                                          kAQSEventName: @"name",
                                                                          kAQSEventArgs: @{
                                                                                  @"key": @"value"
                                                                                  }
                                                                          }];
    
    XCTAssertTrue([notification aqs_isEqualToMeasurementEvent:@"name" args:@{
                                                                             @"key": @"value"
                                                                             }]);
}

- (void)testItIsNotEqualIfEventsNameIsNotSame {
    NSNotification *notification = [NSNotification notificationWithName:kAQSEvent
                                                                 object:nil
                                                               userInfo:@{
                                                                          kAQSEventName: @"name",
                                                                          kAQSEventArgs: @{
                                                                                  @"key": @"value"
                                                                                  }
                                                                          }];
    
    XCTAssertFalse([notification aqs_isEqualToMeasurementEvent:@"wrong_name" args:@{
                                                                                    @"key": @"value"
                                                                                    }]);
}

- (void)testItIsNotEqualIfEventsArgsIsNotSame {
    NSNotification *notification = [NSNotification notificationWithName:kAQSEvent
                                                                 object:nil
                                                               userInfo:@{
                                                                          kAQSEventName: @"name",
                                                                          kAQSEventArgs: @{
                                                                                  @"key": @"value"
                                                                                  }
                                                                          }];
    
    XCTAssertFalse([notification aqs_isEqualToMeasurementEvent:@"name" args:@{
                                                                              @"wrong_key": @"wrong_value"
                                                                              }]);
}

- (void)testItCanUseForNotificationExpectation {
    XCTestExpectation *expectation = [self expectationForNotification:kAQSEvent object:nil handler:^BOOL(NSNotification *notification) {
        [expectation fulfill];
        
        return [notification aqs_isEqualToMeasurementEvent:@"name" args:@{@"key": @"value"}];
    }];
    
    [AQSEvent postEvent:@"name" args:@{@"key": @"value"}];
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

@end
