# LINE SDK starter application

This is a small toy app that exercises the LINE SDK login and profile APIs. It is meant to be a starting point
for developers wishing to use these in their own application.

## Before starting

To start integrating your service with LINE, register to become a LINE Partner (https://developers.line.me/requestform/input) and read the development guide (https://developers.line.me/ios/overview).

## Getting started

To build the app, first check out the repository.

```
$ git clone https://github.com/linecorp/line-sdk-starter
```

Then set up the LINE SDK by copying SDK libraries and configuring your channel ID.

* Copy and add target the framework and bundle files
* Replace {YOUR_URL_SCHEME} with your channel scheme (from https://developers.line.me/channels/) in Info.plist
* Replace {YOUR_CHANNEL_ID} with your channel id (from https://developers.line.me/channels/) in LineAdapter.plist

Then open the directory in Xcode and build and develop as you would any normal iOS application.

LINE iOS SDK API Docs: https://developers.line.me/ios/api-reference

This application has been built with Xcode 6.4.
