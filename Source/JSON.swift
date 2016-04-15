//
//  JSON.swift
//  WistiaKitDemo
//
//  Created by Jake Young on 3/30/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

public enum JSONError: ErrorType {
    case InvalidValue(message: String)
    case EmptyValue(message: String)
    
    case EmptyResults(message: String)
}

public typealias JSONInfo = [String: AnyObject]
public typealias JSONCollection = [JSONInfo]

public protocol SupportsJSONSerialization: JSONSerializable {
    
}

public protocol JSONSerializable {
    init?(json: JSONInfo) throws
    static func parseCollection(json: JSONCollection) throws -> [Self]
}

public extension SupportsJSONSerialization {
    
    static func parseCollection(json: JSONCollection) throws -> [Self] {
        return try json.flatMap { try Self(json: $0) }
    }
    
}