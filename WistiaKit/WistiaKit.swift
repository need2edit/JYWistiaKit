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

public protocol WistiaCollectionItem: CustomStringConvertible {
    associatedtype T
    var children: [T] { get }
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
    
    public static var debugMode: Bool = false
    
    static var sharedInstance: Wistia = Wistia()
    
    /// The global API Password for singleton use
    public static var api_password: String {
        return sharedInstance.api_password
    }
    
    /// The global API Password for singleton use
    public static var numberOfProjects: Int {
        return sharedInstance.projects.count
    }
    
    public static var numberOfMedias: Int {
        return sharedInstance.medias.count
    }
    
    public var projects: [Project] = []
    public var medias: [Media] = []
    
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

// TODO: This request could be encapsulated

/// Lists Projects from Wistia Library
public func List(requestType: WistiaCollectionRequestType = .Projects, page: Int = 0, per_page: Int = 25, sortBy: SortByDescriptor = .Updated, sortDirection: SortDirection = .Ascending, completionHandler: (items: [Project]) -> Void) {
    
    List(requestType, page: page, per_page: per_page, sortBy: sortBy, sortDirection: sortDirection) { (items) -> Void in
        completionHandler(items: items.map { $0 as Project })
    }
    
}

/// Lists Medias from Wistia Library
public func List(requestType: WistiaCollectionRequestType = .Medias, page: Int = 0, per_page: Int = 25, sortBy: SortByDescriptor = .Updated, sortDirection: SortDirection = .Ascending, completionHandler: (items: [Media]) -> Void) {
    
    List(requestType, page: page, per_page: per_page, sortBy: sortBy, sortDirection: sortDirection) { (items) -> Void in
        completionHandler(items: items.map { $0 as Media })
    }
    
}

/// Lists Data Items from Wistia Library
public func List(requestType: WistiaCollectionRequestType, page: Int = 0, per_page: Int = 25, sortBy: SortByDescriptor = .Updated, sortDirection: SortDirection = .Ascending, completionHandler: (items: [WistiaDataItem]) -> Void) {
    
    let URLParams = [
        "page": "\(page)",
        "per_page": "\(per_page)",
        "sort_by": "\(sortBy.rawValue)",
        "sort_direction": "\(sortDirection.rawValue)",
        "api_password": "\(Wistia.api_password)",
    ]
    
    guard let URL = requestType.URL?.URLByAppendingQueryParameters(URLParams) else { return }
    
    if Wistia.debugMode {
        print(URL)
    }
    
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


/// Shows Media Item with Hashed Identifier
public func Show(requestType: WistiaItemRequestType, completionHandler: (item: Media?) -> Void) {
    Show(requestType) { (item) -> Void in
        completionHandler(item: item as? Media)
    }
}

/// Shows Project Item with Hashed Identifier
public func Show(requestType: WistiaItemRequestType, completionHandler: (item: Project?) -> Void) {
    Show(requestType) { (item) -> Void in
        completionHandler(item: item as? Project)
    }
}

public func Show(requestType: WistiaItemRequestType, completionHandler: (item: WistiaDataItem?) -> Void) {
    
    let URLParams = [
        "api_password": "\(Wistia.api_password)",
    ]
    
    guard let URL = requestType.URL?.URLByAppendingQueryParameters(URLParams) else { return }
    
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