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

/// A request for an multiple Wistia Items, such as a Projects or Medias.
public enum WistiaCollectionRequestType: CustomStringConvertible {
    
    case Projects(page: Int, per_page: Int, sort_by: Int, sort_direction: Int)
    case Medias(page: Int, per_page: Int, sort_by: Int, sort_direction: Int)
    
    var pagingInformation: (page: Int, per_page: Int) {
        switch self {
        case .Projects(page: let page, per_page: let perPage, _, _):
            return (page, perPage)
        case .Medias(page: let page, per_page: let perPage, _, _):
            return (page, perPage)
        }
    }
    
    var sortingInformation: (sort_by: Int, sort_direction: Int) {
        
        switch self {
        case .Projects(_, _, let sort_by, let sort_direction):
            return (sort_by, sort_direction)
        case .Medias(_, _, let sort_by, let sort_direction):
            return (sort_by, sort_direction)
        }
        
    }
    
    var URL: NSURL? {
        
        var authenticatedURL: NSURL?
        
        switch self {
        case .Projects:
            authenticatedURL = DataAPI.Router.ListProjects.URL
        case .Medias:
            authenticatedURL = DataAPI.Router.ListMedias.URL
        }
        
        let URLParams = [
            "api_password": "\(Wistia.api_password)",
            "page": "\(self.pagingInformation.page)",
            "per_page": "\(self.pagingInformation.per_page)",
            "sort_by": "\(self.sortingInformation.sort_by)",
            "sort_direction": "\(self.sortingInformation.sort_direction)",
        ]
        
        return authenticatedURL?.URLByAppendingQueryParameters(URLParams)
        
    }
    
    public var description: String {
        
        switch self {
            
            case .Projects:
                return "Requesting Projects"
            case .Medias:
                return "Requesting Medias"
            
        }
        
    }
}

/// A request for an individual Wistia Item, such as a Project or Media.
public enum WistiaItemRequestType: CustomStringConvertible {
    
    case Project(hashedId: String)
    case Media(hashedId: String)
    
    var URL: NSURL? {
        switch self {
        case .Project(let hashedId):
            return DataAPI.Router.ShowProject(hashed_id: hashedId).URL
        case .Media(let hashedId):
            return DataAPI.Router.ShowMedia(hashed_id: hashedId).URL
        }
    }
    
    public var description: String {
        
        switch self {
            
        case .Project(let hashedId):
            return "Requesting Project with Hashed ID: \(hashedId)"
        case .Media(let hashedId):
            return "Requesting Media with Hashed ID: \(hashedId)"
            
        }
        
    }
    
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

/// The object to encapsulate Wistia related functions and data.
public class Wistia {
    
    static var debugMode: Bool = false
    
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
    
    guard let URL = requestType.URL else { return }
    
    let task = NSURLSession.sharedSession().dataTaskWithURL(URL) { (let data, let response, let error) -> Void in
        
        guard let data = data else { return }
        
        do {
            
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String: AnyObject]] {
               
                
                if Wistia.debugMode {
                    print(requestType.description)
                    print(json)
                }
                
                switch requestType {
                    case .Projects:
                        let items = json.flatMap { Project(json: $0) }
                        completionHandler(items: items.map { $0 as WistiaDataItem })
                    case .Medias:
                        let items = json.flatMap { Media(json: $0) }
                        completionHandler(items: items.map { $0 as WistiaDataItem })
                }
                
            }
            
            
        } catch {
            completionHandler(items: [])
        }
        
        
    }
    
    task.resume()
    
}

public func Show(requestType: WistiaItemRequestType, completionHandler: (item: WistiaDataItem?) -> Void) {
    
    guard let URL = requestType.URL else { return }
    
    let task = NSURLSession.sharedSession().dataTaskWithURL(URL) { (let data, let response, let error) -> Void in
        
        if Wistia.debugMode {
            print(data)
            print(response)
            print(error)
        }
        
        guard let data = data else { return }
        
        do {
            
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject] {
                
                
                // TODO: Error Handling for Attempted Initialization
                
                if Wistia.debugMode {
                    print(requestType.description)
                    print(json)
                }
                
                // TODO: This could be handled by a generic / protocol with a standard initilizer
                switch requestType {
                    
                case .Project:
                    completionHandler(item: Project(json: json))
                case .Media:
                    completionHandler(item: Media(json: json))
                    
                }
                
            }
            
            
        } catch {
            // TODO: Error Handling for No Result
            completionHandler(item: nil)
            
        }
        
        
    }
    
    task.resume()
    
}