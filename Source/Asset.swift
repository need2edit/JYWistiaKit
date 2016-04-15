//
//  Asset.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

public struct Asset {
    
    public let URLString: String
    
    public let type: String
    public let contentType: String
    
    public let width: Int
    public let height: Int
    
    public let fileSize: Int
    
    public init(URLString: String, type: String, contentType: String, width: Int, height: Int, fileSize: Int) {
        
        self.URLString = URLString
        self.type = type
        self.contentType = contentType
        self.width = width
        self.height = height
        self.fileSize = fileSize
        
    }

}

extension Asset {
    
    public var URL: NSURL? {
        return NSURL(string: URLString)
    }
    
}