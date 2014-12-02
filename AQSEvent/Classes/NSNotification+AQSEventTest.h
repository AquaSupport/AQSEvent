//
//  NSNotification+AQSEventTest.h
//  AQSEvent
//
//  Created by kaiinui on 2014/12/02.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A category that helps testing AQSEvent.
 */
@interface NSNotification (AQSEventTest)

- (BOOL)aqs_isEqualToMeasurementEvent:(NSString *)name args:(NSDictionary *)args;

@end
