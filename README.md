AQSEvent
========

![](http://img.shields.io/cocoapods/v/AQSEvent.svg?style=flat) ![](http://img.shields.io/travis/AquaSupport/AQSEvent.svg?style=flat)

Measurement Events: **`NSNotification` as Event for Tracking**

- [Usage](#usage)
  - [Posting a measurement event](#posting-a-measurement-event)
  - [Subscribing to measurement events](#subscribing-to-measurement-events)
  - [Testing Events](#testing-events)
- [Protocol](#protocol)
  - [Advantages](#advantages)
  - [Implementation](#implementation)
- [Installation](#installation)
- [Related Projects](#related-projects)
- [Documentation](#documentation)

Usage
---

### Posting a measurement event

Post a measurement event.

```objc
[AQSEvent postEvent:@"event_name" args:@{
    @"key": @"value"
}];
```

With no arguments.

```objc
[AQSEvent postEvent:@"event_name"];
```

### Subscribing to measurement events

Subscribe measurement events.

```objc
self.observer = [AQSEvent observeWithBlock:^(NSString *eventName, NSDictionary *eventArgs) {
    // Do something with arguments.
    //
    // Typically perform actual tracking events in this block.
}];
```

### Testing Events

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

Protocol
---

A measurement event is an `NSNotification` that conforms to following protocol.

1. **Event**'s notification name should be always same.
2. **Event**'s notification should contain an userInfo that contains following values
  1. The userInfo should contain event name as `NSString`.
  2. The userInfo should contain event parameters as `NSDictionary<NSString, id>`.

### Advantages

#### Testing method invocation is typically hard

Testing invocation of `[Analytics trackSomething]` in a method is nearly impossible.

Taking an analytics instance as initialization arguments? Nonsense.

#### There's no accepted way to post Events with unified format

iOS posts numerous number of `NSNotification`s that notifies App Life Cycle Event and iCloud Event and ...

Also 3rd pirty libraries do so.

However there are too many `NSNotification` name and `userInfo` format. To use them for tracking events, we have to find which `NSNotification` are there, write a lot of `NSNotification` observers and parsing and re-formatting `userInfo` for each formats.

#### Measurement Events might be The Holy Grail

1. It is `NSNotification` based - It means you can test it with `Expecta`'s `notify()`
2. You only have to track `NSNotification` whose name is `kAQSEvent`. Only one observer. You only need to send the args to your analytics tracking code. (As most of analytics provides tracking an event with name and a dictionary params.)

And this is just an `NSNotification`. No magicically things. Easy to understand.

### Implementation

`AQSEvent` provide a helper to post / subscribe Events.

#### Posting an Event

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

#### Subscribing Events

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

Installation
---

```
pod "AQSEvent"
```

Related Projects
---

- [AQSEventAggregator](https://github.com/AquaSupport/AQSEventAggregator) - Aggregates measurement events.

Documentation
---

[appledoc](https://dl.dropboxusercontent.com/u/7817937/___doc___AQSEvent/html/index.html) is provided.

LICENSE
---

```
The MIT License (MIT)

Copyright (c) 2014 AquaSupport

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

