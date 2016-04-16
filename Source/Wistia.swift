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

/// A generic item from the Wistia object graph. These are usually Projects or Medias.  Wistia Data Items items have a unique Hashed Id 
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
    
    /**
     
     The Debugger for Wistia Kit is designed to help you learn what is going on within Wistia Kit.  There are three different levels:
     - `None`: Does not print anything to the console.
     - `Some`: Prints out essential tasks. Specifically each route that is requested and sucess or errors.
     - `Annoying`: Prints out everything.  This means the NSURL networking requests and responses, each endpoint getting called, the JSON coming back, along with success and error aknowledgements.
     
     */
    public enum DebuggingLevel: Int {
        
        /// Silences any logging to the console.
        case None = 0
        
        /// Prints our general tasks as they occur.
        case Some = 1
        
        /// Prints out all networking, parsing, errors, and general tasks.
        case Annoying = 3
    }
    
    public static var debugMode: DebuggingLevel = .None
    
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

public func setup(apiKey: String) {
    Wistia.API.setup(apiKey)
}

/// Lists Data Items from Wistia Library

public enum Result<T> {
    case Success(T)
    case Error(ErrorType)
}

public func list(requestType: WistiaCollectionRequestType, page: Int = 0, per_page: Int = 25, sortBy: SortByDescriptor = .Updated, sortDirection: SortDirection = .Ascending, completionHandler: Result<[WistiaDataItem]> -> Void) throws {
    
            guard let request = try requestType.request(page, per_page: per_page, sortDirection: sortDirection, sortBy: sortBy) else { throw Wistia.Error.InvalidRequest }
            
            if Wistia.debugMode == .Some { print(request.URL) }
    
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (let data, let response, let error) -> Void in
                
                guard let response = response as? NSHTTPURLResponse else {
                    
                    return completionHandler(.Error(Wistia.Error.NoResponse))
                    
                }
                
                if Wistia.debugMode == .Annoying { print(response) }
                
                // TODO: Handle the Wistia Docs Here...this is repetative for now
                
                switch response.statusCode {
                
                case 401:
                    
                    return completionHandler(.Error(Wistia.Error.InvalidAPIKey))
                    
                default:
                    break
                }
                
                guard let data = data where response.statusCode == 200 else { return }
                
                do {
                    
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [[String: AnyObject]] {
                        
                        
                        if Wistia.debugMode == .Some { print(requestType.description) }
                        
                        switch requestType {
                            
                        case .Projects:
                            let items = try json.flatMap { try Project(json: $0) }
                            
                            guard !items.isEmpty else { return completionHandler(.Error(Wistia.Error.EmptyProjects)) }
                            
                            completionHandler(.Success(items.map {$0 as WistiaDataItem}))
                            
                        case .Medias:
                            
                            let items = try json.flatMap { try Media(json: $0) }
                            
                            guard !items.isEmpty else { return completionHandler(.Error(Wistia.Error.EmptyMedias)) }
                            
                            completionHandler(.Success(items.map {$0 as Media}))
                            
                        }
                        
                    }
                    
                    
                } catch {
                    
                    if Wistia.debugMode == .Some {
                        print(error)
                    }
                    
                    completionHandler(.Error(error))
                }
                
                
            }
            
            task.resume()
}

public func show(requestType: WistiaItemRequestType, completionHandler: Result<WistiaDataItem> -> Void) throws {
    
    do {
        guard let request = try requestType.request() else { throw Wistia.Error.InvalidRequest }
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (let data, let response, let error) -> Void in
            
            // FIXME: Refactor this, were repeating code here
            
            guard let response = response as? NSHTTPURLResponse else {
                
                return completionHandler(.Error(Wistia.Error.NoResponse))
                
            }
            
            if Wistia.debugMode == .Annoying {
                print(response)
            }
            
            // TODO: Handle the Wistia Docs Here...this is repetative for now
            
            switch response.statusCode {
                
            case 401:
                
                return completionHandler(.Error(Wistia.Error.InvalidAPIKey))
                
            default:
                break
            }
            
            do {
                
                guard let data = data else { throw Wistia.Error.NoData }
                
                if let json = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as? [String: AnyObject] {
                    
                    
                    // TODO: Error Handling for Attempted Initialization
                    
                    if Wistia.debugMode == .Some { print(requestType.description) }
                    
                    // TODO: This could be handled by a generic / protocol with a standard initilizer
                    switch requestType {
                        
                    case .Project:
                        guard let item = try Project(json: json) else { throw Wistia.Error.EmptyProject }
                        completionHandler(.Success(item))
                    case .Media:
                       guard let item = try Media(json: json) else { throw Wistia.Error.EmptyMedia }
                        completionHandler(.Success(item))
                    }
                    
                }
                
                
            } catch {
                
                // TODO: Error Handling for No Result
                completionHandler(.Error(Wistia.Error.NoData))
                
            }
            
            
        }
        
        task.resume()
        
    } catch {
        print(error)
    }
    
}