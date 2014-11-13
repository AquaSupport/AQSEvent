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
    expect(^{
        [AQSEvent event:@"name" args:@{}];
    }).notify(@"com.parse.bolts.measurement_event");
}

- (void)testItPostsEventWithPassedNameAndArgs {
    NSDictionary *userInfo = @{
                               kAQSEventName: @"name",
                               kAQSEventArgs: @{
                                       @"key": @"value"
                                       }
                               };
    NSNotification *notification = [NSNotification notificationWithName:kAQSEvent object:nil userInfo:userInfo];
    
    expect(^{
        [AQSEvent event:@"name" args:@{@"key": @"value"}];
    }).notify(notification);
}

- (void)testItObservesEvent {
    __block NSString *name = nil;
    [AQSEvent observeWithBlock:^(NSString *eventName, NSDictionary *eventArgs) {
        name = eventName;
    }];
    
    [AQSEvent event:@"name" args:@{
                                   @"key": @"value"
                                   }];
    
    expect(name).will.equal(@"name");
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.parse.bolts.measurement_event" object:nil userInfo:userInfo];
    
    expect(name).will.equal(@"name");
    expect(args).will.equal(@{
                              @"key": @"value"
                              });
}

@end
