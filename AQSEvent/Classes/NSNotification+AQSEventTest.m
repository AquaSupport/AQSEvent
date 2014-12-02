//
//  NSNotification+AQSEventTest.m
//  AQSEvent
//
//  Created by kaiinui on 2014/12/02.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "NSNotification+AQSEventTest.h"

#import "AQSEvent.h"

@implementation NSNotification (AQSEventTest)

- (BOOL)aqs_isEqualToMeasurementEvent:(NSString *)name args:(NSDictionary *)args {
    NSString *notificationName = self.name;
    NSString *eventName = self.userInfo[kAQSEventName];
    NSDictionary *eventArgs = self.userInfo[kAQSEventArgs];
    
    // self.object is always nil if it is a measurement event.
    if (self.object != nil) { return NO; }
    
    // Is it a measurement event?
    if ([notificationName isEqualToString:kAQSEvent] == NO) { return NO; }
    
    // Are the name of the events same?
    if ([eventName isEqualToString:name] == NO) { return NO; }
    
    if ([eventArgs isEqualToDictionary:args]) { return YES; }
    
    return NO;
}

@end
