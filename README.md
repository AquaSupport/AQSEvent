AQSEvent
========

Introducing a concept of Bolt's Measurement Event: **`NSNotification` as Event for Tracking**

Protocol
---

1. **Event**'s notification name should be `com.parse.bolts.measurement_event`.
2. **Event**'s notification should contain an userInfo that contains following values with keys
  1. For key `event_name`, it should contain event name as `NSString`.
  2. For key `event_args`, it should contain event parameters as `NSDictionary`.

Advantage?
---

Putting tracking codes to iOS App is really harmful. This is because

#### Testing method invocation is typically hard

Testing invocation of `[Analytics trackSomething]` in a method is nearly impossible.

Taking an analytics instance as initialization arguments? Nonsense.

#### There's no accepted way to post Events with unified format

iOS posts numerous number of `NSNotification`s that notifies App Life Cycle Event and iCloud Event and ...

Also 3rd pirty libraries do so.

However there are too many `NSNotification` name and `userInfo` format. To use them for tracking events, we have to find which `NSNotification` are there, write a lot of `NSNotification` observers and parsing and re-formatting `userInfo` for each formats.

### Bolt's Measurement Event might be The Holy Grail

1. It is `NSNotification` based - It means you can test it with `Expecta`'s `notify()`
2. You only have to track `NSNotification` whose name is `com.parse.bolts.measurement_event`. Only one observer. The format is unified. You only need to send the args to your analytics tracking code. (As most of analytics provides tracking an event with name and a dictionary params.)

And this is just an `NSNotification`. No magicically things. Easy to understand.

Implementation
---

I provide a helper to post / subscribe Events.

### Posting an Event

Measurement Event constants are defined at `AQSEvent.h` so it can be write as follows

```objc
[[NSNotificationCenter defaultCenter] postNotification:kAQSEvent object:nil userInfo:@{
    kAQSEventName: @"location/changed",
    kAQSEventArgs: @{
        @"latitude": @(40.712784),
        @"longitude": @(-74.005941)
    };
}];
```

And for shorthand, `AQSEvent.m` provides a helper method.

```objc
[AQSEvent event:@"location/changed" args:@{
    @"latitude": @(40.712784),
    @"longitude": @(-74.005941)
}];
```

### Subscribing Events

Subscribe to events are also easy.

```objc
[[NSNotificationCenter defaultCenter] addObserver:kAQSEvent selector:@selector(subscribeEvent:) object:nil];
```

For shorthand and convenience of removing observer, `AQSEventObserver.m` provides a helper.

```objc
@property (nonatomic, strong) AQSEventObserver *eventObserver;

// Then in @implementation,

self.eventObserver = [AQSEventObserver observerWithBlock:^(NSString *eventName, NSDictionary *args) {
    // Do something
}];
```

`AQSEventObserver` removes observer on `- dealloc` so you do not have to worry about memory leak due to forgetting `- removeObserver`.

Testing Events
---

Assume you want to test that following method posts an Event for tracking.

```objc
[someObject doSomething];
```

Just use `Expecta`. You can achieve this with following code.

```objc
expect(^{
    [someObejct doSomething];
}).to.notify(kAQSEvent);
```

Or to test the content of the notification, do as follows

```objc
NSNotification *notification = [NSNotification notificationWithName:kAQSEvent withObject:nil withUserInfo:@{
    kAQSEventName: @"some/evemt"
}];

expect(^{
    [someObject doSomething];
}).to.notify(notification);
```

Testing tracking codes are also easy. Just post a notification and verify that invokes the tracking code.

References
---

- BoltsFramework/Bolts-iOS : https://github.com/BoltsFramework/Bolts-iOS#analytics
