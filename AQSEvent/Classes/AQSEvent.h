//
//  AQSEvent.h
//  AQSEvent
//
//  Created by kaiinui on 2014/11/13.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

# pragma mark - NSNotification Keys

/**
 *  @notification kAQSEvent (a.k.a. `com.parse.bolts.measurement_event`)
 */
extern NSString *const kAQSEvent;

# pragma mark - NSNotification UserInfo Keys

/**
 *  kAQSEvent userInfo: NSString
 *  a.k.a. `event_name` of Bolt's measurement event
 */
extern NSString *const kAQSEventName;
/**
 *  kAQSEvent userInfo: NSDictionary
 *  a.k.a. `event_args` of Bolt's measurement event
 */
extern NSString *const kAQSEventArgs;

# pragma mark - 

@class AQSEventObserver;

/**
 *  A helper class for Bolt's measurement event.
 */
@interface AQSEvent : NSObject

/**
 *  Post a Bolt's measurement event with passed name and args.
 *
 *  @param name An event's name
 *  @param args An event's key-value args
 */
+ (void)event:(NSString *)name args:(NSDictionary *)args;

/**
 *  Observe Bolt's measurement events with passed block.
 *
 *  @param block A block that is called when Bolt's measurement event is posted.
 *
 *  @return An observer you should retain while the observation is needed.
 */
+ (AQSEventObserver *)observeWithBlock:(void(^)(NSString *eventName, NSDictionary *eventArgs))block;

@end
