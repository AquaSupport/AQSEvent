//
//  AQSEventObserver.h
//  AQSEvent
//
//  Created by kaiinui on 2014/11/13.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A class that observes measurement events as long as this class is retained.
 */
@interface AQSEventObserver : NSObject

+ (instancetype)observerWithBlock:(void(^)(NSString *eventName, NSDictionary *eventArgs))block;

@end
