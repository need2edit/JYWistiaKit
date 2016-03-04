//
//  Media.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

public class Media: WistiaDataItem {
    
    public var id: Int
    
    public var hashedId: String
    
    public var publicId: String
    
    public var name: String
    public var summary: String
    
    public var created: String
    public var updated: String
    
    public var assets: [Asset] = []
    
    public typealias T = Asset
    
    public var children: [T] {
        return assets
    }
    
    public init(id: Int, hashedId: String, publicId: String, name: String, summary: String, updated: String, created: String, assets: [Asset] = []) {
        
        self.id = id
        self.hashedId = hashedId
        self.publicId = publicId
        
        
        self.name = name
        self.summary = summary
        
        self.updated = updated
        self.created = created
        
    }

}