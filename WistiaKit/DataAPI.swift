//
//  DataAPI.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

/// The centralized router for managing Wistia API Requests
public final class DataAPI: APIRouter {
    
    static let sharedInstance: DataAPI = DataAPI()
    static var baseURLString: String = "https://api.wistia.com/"
    static var version: String = "v1/"
    
    /// The centralized router for managing Wistia API Requests
    public enum Router: APIRoute {
        
        /// Get All Projects
        case ListProjects
        
        /// Get a Project for a Specified ID
        case ShowProject(hashed_id: String)
        
        /// Get All Medias
        case ListMedias
        
        /// Get the Media Item for a Specified ID
        case ShowMedia(hashed_id: String)
        
        /// Get the Medias for a Specified Project
        case ListMediasForProject(hashed_id: String)
        
        public var method: HTTPMethod {
            return .GET
        }
        
        public var routeURLString: String {
            switch self {
            case .ListProjects:
                return "projects.json"
            case .ShowProject(hashed_id: let hashed_id):
                return "projects/\(hashed_id).json"
            case .ListMedias:
                return "medias.json"
            case .ShowMedia(hashed_id: let hashed_id):
                return "medias/\(hashed_id).json"
            default:
                return ""
            }
        }
        
        public var URLString: String {
            return DataAPI.baseURLString + version + routeURLString
        }
        
        public var URL: NSURL? {
            return NSURL(string: URLString)
        }
        
    }
    
}