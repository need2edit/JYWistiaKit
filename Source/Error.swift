//
//  Error.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

public protocol WistiaErrorType: CustomDebugStringConvertible, CustomStringConvertible {}

public enum AssetError: WistiaErrorType {
    
    case InvalidURL
    case InvalidFormat
    
    public var description: String {
        switch self {
        case .InvalidURL:
            return "The URL provided is invalid."
        case .InvalidFormat:
            return "This asset is not viewable on this device."
        }
    }
    
    public var debugDescription: String {
        switch self {
            case .InvalidURL:
                return self.description + " This will make it impossible to play or view the asset on the device."
            case .InvalidFormat:
                return self.description + " This is probably due to a flash format provided in the deliveries."
        }
    }
}

extension Wistia {
    
    public enum Error: ErrorType, CustomStringConvertible {
        
        case InvalidAPIKey
        
        case NoResponse
        
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
            case NoResponse:
                return "Did not receive a response from Wistia."
            case .InvalidAPIKey:
                return "The API password you provided is invalid."
            case .EmptyAPIKey:
                return "You did not provide an API password. Use Wistia.setup(\"your-api-password\") to get started."
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
    
}