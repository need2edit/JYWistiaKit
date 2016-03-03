
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
 
A Swift framework for working with Wistia. 

Written by a big Wistia fan...so this is unofficial.

If you havent heard of Wistia, you're missing out [https://wistia.com].

## v1.0 is just in beta right now... its not even networked yet.  Hope to have this done March 2016.

## Features

- [x] Easy setup with an API Key
- [x] Wistia Objects for Projects, Medias, and Assets
- [x] Written in a style consistent with the Wistia Data API

## Upcoming Features

- [] Error Handling
- [] Video Playback with AVKit
- [] Video Playback with UIWebView supporting Wistia Analytics

## Resources

- [Wistia Data API](https://wistia.com/doc/data-api)

For general style and development, please visit https://wistia.com/doc/data-api

## Getting Started

To communicate with the Wistia backend you'll need and API token.

```swift
// Setup your Wistia account
WistiaKit.setup(api_password: "024f878666115ae66834e2e3c9827523be00be4b27a0298aa672711310614735")
```

## Usage

Listing Projects looks like this:

```swift
WistiaKit.List(.Projects) { (items) -> Void in
// Do something with these projects item
}
```

Listing Medias looks like this:

```swift
WistiaKit.List(.Medias) { (items) -> Void in
// Do something with these medias item
}
```

Showing a Single Project looks like this:

```swift
WistiaKit.Show(.Project(hashedId: "x8371jj")) { (item) -> Void in
// Do something with this project item
}
```

Showing a Single Media looks like this:

```swift
WistiaKit.Show(.Media(hashedId: "x8371jj")) { (item) -> Void in
// Do something with this media item
}
```