//
//  AQSEvent.m
//  AQSEvent
//
//  Created by kaiinui on 2014/11/13.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQSEvent.h"

#import "AQSEventObserver.h"

NSString *const kAQSEvent = @"org.openaquamarine.measurement_event";
NSString *const kAQSEventName = @"event_name";
NSString *const kAQSEventArgs = @"event_args";

@implementation AQSEvent

+ (void)postEvent:(NSString *)name {
    [self postEvent:name args:nil];
}

+ (void)postEvent:(NSString *)name args:(NSDictionary *)args {
    if (args == nil) { args = @{}; }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQSEvent
                                                        object:nil
                                                      userInfo:@{
                                                                 kAQSEventName: name,
                                                                 kAQSEventArgs: args
                                                                 }];
}

+ (AQSEventObserver *)observeWithBlock:(void (^)(NSString *, NSDictionary *))block {
    return [AQSEventObserver observerWithBlock:block];
}

# pragma mark - Deprecated Methods

+ (void)event:(NSString *)name args:(NSDictionary *)args {
    [self postEvent:name args:args];
}

@end
