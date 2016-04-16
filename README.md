
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
 
A Swift framework for working with Wistia. 

Written by a fan of Wistia...so this is unofficial.

If you havent heard of Wistia, you're missing out [https://wistia.com].

v0.1 is just in beta right now... Shooting for a first major release in April 2016. All of this documentation is subject to change.

I prefer Carthage, Cocoapods is on the list. 

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
- Results returned as Media or Project items directly instead of having to switch on .Success and .Error enums
- Demo iOS Project
- Demo tvOS Project
- Demo macOS Project

## Resources

- [Wistia Data API](https://wistia.com/doc/data-api)

For general style and development, please visit https://wistia.com/doc/data-api

## Getting Started

To communicate with the Wistia backend you'll need and API token.

See the iOS project for a working example.

```swift

// Setup your Wistia account with an API Key
WistiaKit.setup("my-wistia-api-goes-here")

```

## Usage

Listing Projects looks like this:

```swift
// Fetch a list of projects.

do {

    try WistiaKit.list(.Projects, completionHandler: { (result) in
        
        switch result {
            
        case .Success(let projects):
            
            // Do something with your projects
            print(projects)
            
        case .Error(let error):

            // React to the error of why projects specifically were not returned.

        }
    })

}

catch {

    // React to other system related errors if you need to.
    print(error)

}
```

Listing Medias looks like this:

```swift
do {

    try WistiaKit.list(.Medias, completionHandler: { (result) in
        
        switch result {
            
        case .Success(let medias):
            
            // Do something with your medias
            print(medias)
            
        case .Error(let error):

            // React to the error of why medias specifically were not returned.

        }
    })

}

catch {

    // React to other system related errors if you need to.
    print(error)

}
```

Showing a Single Project looks like this:

```swift
do {

    try WistiaKit.show(.Project("x837d1jj", completionHandler: { (result) in
        
        switch result {
            
        case .Success(let project):
            
            // Do something with your project
            print(project)
            
        case .Error(let error):

            // React to the error of why the project was not returned.

        }
    })

}

catch {

    // React to other system related errors if you need to.
    print(error)

}

```

Showing a Single Media looks like this:

```swift
do {

    try WistiaKit.show(.Media("x837d1jj", completionHandler: { (result) in
        
        switch result {
            
        case .Success(let media):
            
            // Do something with your project
            print(project)
            
        case .Error(let error):

            // React to the error of why the project was not returned.

        }
    })

}

catch {

    // React to other system related errors if you need to.
    print(error)

}
```