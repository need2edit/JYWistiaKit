//
//  API.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

/// An enum to wrap HTTP methods for routing.  Each route will have a method type for getting or updating items.
public enum HTTPMethod: String {
    case GET = "GET"
    case PUT = "PUT"
    case UPDATE = "UPDATE"
    case POST = "POST"
    case DELETE = "DELETE"
}

/// Router Types Must Declare a Router, Typically an Enum
protocol APIRouter {
    
    associatedtype Router: APIRoute
    
}

protocol APIRoute {
    
    var method: HTTPMethod { get }
    
    var routeURLString: String { get }
    
    var URLString: String { get }
    var URL: NSURL? { get }
    
}

protocol API {
    
    static var sharedInstance: Self { get }
    static var baseURLString: String { get set }
    static var version: String { get set }
    
}