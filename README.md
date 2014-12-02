AQSEvent
========

Measurement Events: **`NSNotification` as Event for Tracking**

Usage
---

Post a measurement event.

```objc
[AQSEvent postEvent:@"event_name" args:@{
    @"key": @"value"
}];
```

Observe measurement events.

```objc
self.observer = [AQSEvent observeWithBlock:^(NSString *eventName, NSDictionary *eventArgs) {
    // Do something with arguments.
    //
    // Typically perform actual tracking events in this block.
}];
```

Protocol
---

A measurement event is an `NSNotification` that conforms to following protocol.

1. **Event**'s notification name should be always same.
2. **Event**'s notification should contain an userInfo that contains following values
  1. The userInfo should contain event name as `NSString`.
  2. The userInfo should contain event parameters as `NSDictionary<NSString, id>`.

Advantage?
---

#### Testing method invocation is typically hard

Testing invocation of `[Analytics trackSomething]` in a method is nearly impossible.

Taking an analytics instance as initialization arguments? Nonsense.

#### There's no accepted way to post Events with unified format

iOS posts numerous number of `NSNotification`s that notifies App Life Cycle Event and iCloud Event and ...

Also 3rd pirty libraries do so.

However there are too many `NSNotification` name and `userInfo` format. To use them for tracking events, we have to find which `NSNotification` are there, write a lot of `NSNotification` observers and parsing and re-formatting `userInfo` for each formats.

### Measurement Events might be The Holy Grail

1. It is `NSNotification` based - It means you can test it with `Expecta`'s `notify()`
2. You only have to track `NSNotification` whose name is `kAQSEvent`. Only one observer. You only need to send the args to your analytics tracking code. (As most of analytics provides tracking an event with name and a dictionary params.)

And this is just an `NSNotification`. No magicically things. Easy to understand.

Implementation
---

`AQSEvent` provide a helper to post / subscribe Events.

### Posting an Event

```objc
[AQSEvent postEvent:@"location/changed" args:@{
    @"latitude": @(40.712784),
    @"longitude": @(-74.005941)
}];
```

This is a shorthand for following code.

```objc
[[NSNotificationCenter defaultCenter] postNotification:kAQSEvent object:nil userInfo:@{
    kAQSEventName: @"location/changed",
    kAQSEventArgs: @{
        @"latitude": @(40.712784),
        @"longitude": @(-74.005941)
    };
}];
```

### Subscribing Events

Subscribe to events are also easy.

`AQSEvent` provides a helper.

```objc
@property (nonatomic, strong) AQSEventObserver *eventObserver;

// Then in @implementation,

self.eventObserver = [AQSEvent observeWithBlock:^(NSString *eventName, NSDictionary *eventArgs) {
    // Do something
}];
```

This is a shorthand for following code.

```objc
[[NSNotificationCenter defaultCenter] addObserver:kAQSEvent selector:@selector(subscribeEvent:) object:nil];
```

`AQSEventObserver` automatically does `- removeObserver:` on `- dealloc`. No more memory leak as long as you use `AQSEvent` to observe events.

Testing Events
---

Assume you want to test that following method posts an Event for tracking.

```objc
[someObject doSomething];
```

`XCTestExpectation` helps you testing measurement events. And `AQSEvent` provides a helper category for easier testing.

```objc
- (void)testItPostsSomeMeasurementEvent {
    XCTestExpectation *expectation = [self expectationForNotification:kAQSEvent object:nil handler:BOOL^(NSNotification *notification) {
        [expectation fulfill];
        
        return [notification aqs_isEqualToMeasurementEvent:@"event_name" args:@{@"key": @"value"}];
    }];
    
    [someObject doSomething]; // Assume it posts "event_name" event with {"key": "value"}
    
    [self waitForExpectationWithTimeout:1.0 handler:nil];
}
```

Installation
---

```
pod "AQSEvent"
```

Related Projects
---

- [AQSEventAggregator](https://github.com/AquaSupport/AQSEventAggregator) - Aggregates measurement events.
