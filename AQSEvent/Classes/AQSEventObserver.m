//
//  AQSEventObserver.m
//  AQSEvent
//
//  Created by kaiinui on 2014/11/13.
//  Copyright (c) 2014年 Aquamarine. All rights reserved.
//

#import "AQSEventObserver.h"

#import "AQSEvent.h"

typedef void(^AQSEventObserveBlock)(NSString *eventName, NSDictionary *eventArgs);

@interface AQSEventObserver ()

@property (nonatomic, strong) AQSEventObserveBlock block;

@end

@implementation AQSEventObserver

+ (instancetype)observerWithBlock:(AQSEventObserveBlock)block {
    return [[self alloc] initWithBlock:block];
}

# pragma mark - Initialization

- (instancetype)initWithBlock:(AQSEventObserveBlock)block {
    self = [super init];
    if (self) {
        self.block = block;
        [self startObserveEventNotification];
    }
    return self;
}

# pragma mark - Observe

- (void)startObserveEventNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeBlock:) name:kAQSEvent object:nil];
}

- (void)observeBlock:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *eventName = userInfo[kAQSEventName];
    NSDictionary *eventArgs = userInfo[kAQSEventArgs];
    
    self.block(eventName, eventArgs);
}

# pragma mark - Lifecycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
