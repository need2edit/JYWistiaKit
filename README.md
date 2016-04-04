
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
 
A Swift framework for working with Wistia. 

Written by a fan of Wistia...so this is unofficial.

If you havent heard of Wistia, you're missing out [https://wistia.com].

v0.1 is just in beta right now... Shooting for a release in April 2016. All of this is subject to change as I reach that milestone.

I prefer Carthage, cocoapods support may come later, but no promises. 

## High Level Goals

- Provide an easy way to interact with the Wistia Data API
- Create models mapped with Wistia Data Objects
- Error Handling for Wistia, JSON, and Media and Asset Bugs 

## Features

- [x] Easy setup with an API Key
- [x] Error Handling!
- [x] Wistia Objects for Projects, Medias, and Assets
- [x] Helpers for working with Wistia Asset URLs
- [x] Written in a friendly familiar style consistent with the Wistia Data API

## Upcoming Features

- Error Handling consistent with the API documentation
- Video Playback with AVKit
- Video Playback with UIWebView supporting Wistia Analytics
- Demo UI Projects

## Resources

- [Wistia Data API](https://wistia.com/doc/data-api)

For general style and development, please visit https://wistia.com/doc/data-api

## Getting Started

To communicate with the Wistia backend you'll need and API token.

```swift
// Setup your Wistia account with an API Key
Wistia.setup("024f878666115ae66834fdsfase2e3c98b27a0298aa672711310614735")
```

## Usage

Listing Projects looks like this:

```swift
Wistia.list(.Projects) { (items) -> Void in
    // Do something with your list of projects here
}
```

Listing Medias looks like this:

```swift
Wistia.list(.Medias) { (items) -> Void in
    // Do something with your list of medias here
}
```

Showing a Single Project looks like this:

```swift
Wistia.show(.Project("x837d1jj")) { (item) -> Void in
    // Do something with this project item
}
```

Showing a Single Media looks like this:

```swift
Wistia.show(.Media("x8371jj")) { (item) -> Void in
    // Do something with this media item
}
```