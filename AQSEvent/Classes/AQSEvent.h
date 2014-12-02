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
 *  @notification kAQSEvent
 *  @object nil
 *
 *  ### userInfo
 *
 *  - kAQSEventName: NSString
 *  - kAQSEventArgs: NSDictionary<NSString, id>
 */
extern NSString *const kAQSEvent;

# pragma mark - NSNotification UserInfo Keys

/**
 *  kAQSEvent userInfo: NSString
 */
extern NSString *const kAQSEventName;
/**
 *  kAQSEvent userInfo: NSDictionary
 */
extern NSString *const kAQSEventArgs;

# pragma mark - 

@class AQSEventObserver;

/**
 *  A helper class for handling measurement events.
 */
@interface AQSEvent : NSObject

# pragma mark - Posting a Measurement Event
/** @name Posting a Measurement Event */

/**
 *  Post a measurement event with passed name.
 *  With some arguments, use `+ postEvent:args:` instead.
 *
 *  @param name An event's name
 */
+ (void)postEvent:(NSString *)name;

/**
 *  Post a measurement event with passed name and args.
 *
 *  @param name An event's name
 *  @param args An event's key-value args
 */
+ (void)postEvent:(NSString *)name args:(NSDictionary *)args;

# pragma mark - Observing Measurement Events
/** @name Observing Measurement Events */

/**
 *  Observe measurement events with passed block as long as the returned observer is retained.
 *
 *  @param block A block that is called when a measurement event which is specified by eventName is posted.
 *
 *  @return An observer you should retain while the observation is needed.
 */
+ (AQSEventObserver *)observeWithBlock:(void(^)(NSString *eventName, NSDictionary *eventArgs))block;

# pragma mark - Deprecated Methods
/** @name Deprecated Methods */

/**
 *  Post a measurement event with passed name and args.
 *
 *  @param name An event's name
 *  @param args An event's key-value args
 */
+ (void)event:(NSString *)name args:(NSDictionary *)args __deprecated;

@end
