//
//  APITemplate.swift
//  WistiaKitDemo
//
//  Created by Jake Young on 3/29/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

/// HTTPS vs. HTTP protocols
public enum HTTPProtocol: String {
    case HTTPS = "https://"
    case HTTP = "http://"
    case FILE = "file://"
}

public enum RESTMethod: String {
    case GET = "GET"
    case PUT = "PUT"
    case POST = "POST"
    case UPDATE = "UPDATE"
    case DELETE = "DELETE"
}

public protocol RouteType: URLQueryParameterStringConvertible {
    var method: RESTMethod { get }
    var action: String { get }
    var resource: String { get }
    var endpoint: String { get }
}

/** Objects conforming to the API template provide versioning, base URL, and routing functionality.
 
 - parameter API: A singleton instance of this item for centralized managment.
 - parameter HOSTProtocol: Base HTTP protocol for the
 
 */
public protocol APITemplate {
    
    static var API: Self { get set }
    
    var httpProtocol: HTTPProtocol { get }
    
    var apiKey: String? { get set }
    
    func setup(apiKey: String)
    
    var baseURLString: String { get }
    var baseURL: NSURL? { get }
    
    var host: String { get }
    var version: String { get }
    
    associatedtype Endpoint: RouteType
    associatedtype Error: ErrorType, CustomStringConvertible
}

extension APITemplate {
    
    /// Setup Singleton API with Key
    public func setup(apiKey: String) {
        Self.API.apiKey = apiKey
    }
    
    /// Base Fully Formed URL String
    public var baseURLString: String {
        return "\(httpProtocol.rawValue)\(host)/\(version)/"
    }
    
    /// Base Fully Formed URL
    public var baseURL: NSURL? {
        return NSURL(string: baseURLString)
    }
    
}

public func base64EncodedString(username: String, password: String) -> String? {
    let loginString = NSString(format: "%@:%@", username, password)
    guard let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding) else { return nil }
    let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    return base64LoginString
}