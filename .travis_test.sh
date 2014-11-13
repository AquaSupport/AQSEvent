#!/bin/bash

xcodebuild -workspace AQSEvent.xcworkspace -scheme AQSEvent -destination 'platform=iOS Simulator,name=iPhone 6,OS=8.1' test | xcpretty -c && exit ${PIPESTATUS[0]}

