//
//  AQSEventTests.m
//  AQSEventTests
//
//  Created by kaiinui on 2014/11/13.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import <Expecta.h>

#import "AQSEvent.h"
#import "AQSEventObserver.h"

@interface AQSEventTests : XCTestCase

@end

@implementation AQSEventTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testItPostsMeasurementEvent {
    XCTestExpectation *expectation = [self expectationForNotification:kAQSEvent object:nil handler:^BOOL(NSNotification *notification) {
        [expectation fulfill];
        
        return YES;
    }];
    
    [AQSEvent postEvent:@"name" args:@{@"key": @"value"}];
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testItPostsEventWithPassedNameAndArgs {
    XCTestExpectation *expectation = [self expectationForNotification:kAQSEvent object:nil handler:^BOOL(NSNotification *notification) {
        [expectation fulfill];
        
        NSString *eventName = notification.userInfo[kAQSEventName];
        NSDictionary *eventArgs = notification.userInfo[kAQSEventArgs];
        
        return ([eventName isEqualToString:@"name"] && [eventArgs isEqualToDictionary:@{@"key": @"value"}]);
    }];
    
    [AQSEvent postEvent:@"name" args:@{@"key": @"value"}];
    
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testItObservesEvent {
    __block NSString *name = nil;
    
    [AQSEvent observeWithBlock:^(NSString *eventName, NSDictionary *eventArgs) {
        name = eventName;
    }];
    [AQSEvent postEvent:@"name" args:@{
                                   @"key": @"value"
                                   }];
    
    XCTAssertEqualObjects(name, @"name");
}

- (void)testItObservesManualMeasurementEvent {
    __block NSString *name = nil;
    __block NSDictionary *args = nil;
    NSDictionary *userInfo = @{
                               @"event_name": @"name",
                               @"event_args": @{
                                       @"key": @"value"
                                       }
                               };
    [AQSEvent observeWithBlock:^(NSString *eventName, NSDictionary *eventArgs) {
        name = eventName;
        args = eventArgs;
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQSEvent object:nil userInfo:userInfo];
    
    XCTAssertEqualObjects(name, @"name");
    XCTAssertEqualObjects(args, @{@"key": @"value"});
}

@end
