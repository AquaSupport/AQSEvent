//
//  AQSEvent.m
//  AQSEvent
//
//  Created by kaiinui on 2014/11/13.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQSEvent.h"

#import "AQSEventObserver.h"

NSString *const kAQSEvent = @"com.parse.bolts.measurement_event";
NSString *const kAQSEventName = @"event_name";
NSString *const kAQSEventArgs = @"event_args";

@implementation AQSEvent

+ (void)event:(NSString *)name args:(NSDictionary *)args {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAQSEvent object:nil userInfo:@{
                                                                                               kAQSEventName: name,
                                                                                               kAQSEventArgs: args
                                                                                               }];
}

+ (AQSEventObserver *)observeWithBlock:(void (^)(NSString *, NSDictionary *))block {
    return [AQSEventObserver observerWithBlock:block];
}

@end
