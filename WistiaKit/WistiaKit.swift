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

protocol WistiaDataSourceManager {
    
    /// Projects currently in Wistia
    var projects: [Project] { get set }
    
    /// The Number of Wistia Projects Present
    var numberOfProjects: Int { get }
    
    /// Medias currently in Wistia
    var medias: [Media] { get set }
    
    /// The Number of Media Items
    var numberOfMedias: Int { get }
    
}

extension WistiaDataSourceManager {
    
    var numberOfProjects: Int {
        return projects.count
    }
    
    var numberOfMedias: Int {
        return medias.count
    }
    
}


/// The object to encapsulate Wistia related functions and data.
public struct Wistia: APITemplate, WistiaDataSourceManager {
    
    public static var debugMode: Bool = false
    
    // MARK: Wistia Data API
    
    /// The global API Password for singleton use
    public static var API: Wistia = Wistia()
    
    /// Wistia's default
    public var httpProtocol: HTTPProtocol {
        return .HTTPS
    }
    
    /// API Password for a given instance
    public var apiKey: String?
    
    /// The Base URL or Host of the API
    public var host: String {
        return "api.wistia.com"
    }
    
    /// The Version of the API
    public var version: String {
        return "v1"
    }
    
    
    public enum Error: ErrorType, CustomStringConvertible {
        
        case InvalidAPIKey
        case EmptyAPIKey
        
        case InvalidBaseURL
        
        case EmptyProjects
        case EmptyMedias
        
        case EmptyProject
        case EmptyMedia
        
        case NoData
        
        case RateLimitExceeded
        
        case InvalidRequest
        
        public var description: String {
            switch self {
            case .InvalidAPIKey:
                return "The API password you provided is invalid."
            case .EmptyAPIKey:
                return "You did not provide an API password. Use Wistia.setup(apiKey:String) to get started."
            case .InvalidBaseURL:
                return "Could not create the base URL for the API"
            case .RateLimitExceeded:
                return "You've requested things over 1000 times in a minute.  Wistia's pretty fun, but you might need to calm down a bit."
            case .InvalidRequest:
                return "The request you're trying to make is invalid, please check your parameter formatting and try again."
            case .EmptyMedia:
                return "No media information was returned for the hashed id you provided."
            case .EmptyProject:
                return "No project information was returned for the hashed id you provided."
            case .EmptyMedias:
                return "No medias were found for the current request."
            case .EmptyProjects:
                return "No projects were "
            case .NoData:
                return "No data was returned for this request."
            }
        }
    }
    
    public enum Endpoint: RouteType {
        
        /// List Medias
        case ListMedias
        
        /// Show a Single Media Using a Hashed ID
        case ShowMedia(hashedId: String)
        
        
        /// List Projects within Wistia
        case ListProjects
        
        /// Show Individual Project
        case ShowProject(hashedId: String)
        
        public var method: RESTMethod {
            switch self {
        case .ListMedias, .ListProjects, .ShowMedia(hashedId: _), .ShowProject(hashedId: _):
                return .GET
            }
        }
        
        public var action: String {
            
            switch self {
                
            case .ListProjects:
                return ".json"
            case .ListMedias:
                return ".json"
            case .ShowMedia(hashedId: let hashedId):
                return "/\(hashedId).json"
            case .ShowProject(hashedId: let hashedId):
                return "/\(hashedId).json"
            }
            
        }
        
        public var endpoint: String {
            return resource + action
        }
        
        public var resource: String {
            switch self {
            case .ListProjects, .ShowProject(hashedId: _):
                return "projects"
            case .ListMedias, .ShowMedia(hashedId: _):
                return "medias"
            }
        }
        
        public var queryParameters: String {
            return ""
        }
        
    }
    
    
    // MARK: Wistia Data Source
    public var projects: [Project] = []
    public var medias: [Media] = []
    
    
}

/// Lists Data Items from Wistia Library

public func List(requestType: WistiaCollectionRequestType, page: Int = 0, per_page: Int = 25, sortBy: SortByDescriptor = .Updated, sortDirection: SortDirection = .Ascending, completionHandler: (items: [WistiaDataItem]) -> Void) {
        
        do {
            
            guard let request = try requestType.request(page, per_page: per_page, sortDirection: sortDirection, sortBy: sortBy) else { throw Wistia.Error.InvalidRequest }
            
            if Wistia.debugMode {
                print(request.URL)
            }
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (let data, let response, let error) -> Void in
                
                guard let data = data else { return }
                
                do {
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String: AnyObject]] {
                        
                        
                        if Wistia.debugMode {
                            print(requestType.description)
                        }
                        
                        switch requestType {
                        case .Projects:
                            let items = try json.flatMap { try Project(json: $0) }
                            completionHandler(items: items.map { $0 as WistiaDataItem })
                        case .Medias:
                            let items = try json.flatMap { try Media(json: $0) }
                            completionHandler(items: items.map { $0 as WistiaDataItem })
                        }
                        
                    }
                    
                    
                } catch {
                    completionHandler(items: [])
                }
                
                
            }
            
            task.resume()
            
        }
        
        catch {
            print(error)
        }
    
}


public func Show(requestType: WistiaItemRequestType, completionHandler: (item: WistiaDataItem?) -> Void) {
    
    do {
        guard let request = try requestType.request() else { throw Wistia.Error.InvalidRequest }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (let data, let response, let error) -> Void in
            
            do {
                
                guard let data = data else { throw Wistia.Error.NoData }
                
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject] {
                    
                    
                    // TODO: Error Handling for Attempted Initialization
                    
                    if Wistia.debugMode {
                        print(requestType.description)
                    }
                    
                    // TODO: This could be handled by a generic / protocol with a standard initilizer
                    switch requestType {
                        
                    case .Project:
                        completionHandler(item: try Project(json: json))
                    case .Media:
                        completionHandler(item: try Media(json: json))
                        
                    }
                    
                }
                
                
            } catch {
                // TODO: Error Handling for No Result
                completionHandler(item: nil)
                
            }
            
            
        }
        
        task.resume()
        
    } catch {
        print(error)
    }
    
}