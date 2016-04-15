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