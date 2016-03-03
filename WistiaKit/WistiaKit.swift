//
//  WistiaKit.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

/*

We'll use Wistia's wonderful Data API as our bluprint.

*/

public enum WistiaCollectionRequestType {
    case Projects
    case Medias
}

public enum WistiaItemRequestType {
    case Project(hashedId: String)
    case Media(hashedId: String)
}

/// A generic item from the Wistia object graph. These are usually Projects or Medias.
public protocol WistiaDataItem: CustomStringConvertible {
    var hashedId: String { get set }
}

extension WistiaDataItem {
    public var description: String {
        return "Hashed ID: \(self.hashedId)"
    }
}

// TODO: Using type aliases for now until we have concrete objects to work with
public typealias Asset = String

/// The object to encapsulate Wistia related functions and data.
public class Wistia {
    static var sharedInstance: Wistia = Wistia()
    
    /// The global API Password for singleton use
    static var api_password: String {
        return sharedInstance.api_password
    }
    
    /// The global API Password for singleton use
    static var numberOfProjects: Int {
        return sharedInstance.projects.count
    }
    
    static var numberOfMedias: Int {
        return sharedInstance.medias.count
    }
    
    var projects: [Project] = []
    var medias: [Media] = []
    
    /// API Password for a given instance
    private var api_password: String = ""
}

public func setup(api_password api_password: String) {
    Wistia.sharedInstance.api_password = api_password
}

public func request(route: DataAPI.Router) {
    
    if Wistia.api_password.isEmpty  {
        print("You have not set an API Password... aborting")
        return
    } else {
        
        print("Projects: \(Wistia.numberOfProjects)")
        print("Medias: \(Wistia.numberOfMedias)")
        
        print(route.URL)
    }
    
}

public func List(requestType: WistiaCollectionRequestType, completionHandler: (items: [WistiaDataItem]) -> Void) {
    
    completionHandler(items: [])
    
}

public func Show(requestType: WistiaItemRequestType, completionHandler: (item: WistiaDataItem?) -> Void) {
    
    switch requestType {
    case .Project(let hashedId):
        completionHandler(item: Project(hashedId: hashedId))
    case .Media(let hashedId):
        completionHandler(item: Media(hashedId: hashedId))
    }
    
    completionHandler(item: nil)
    
}