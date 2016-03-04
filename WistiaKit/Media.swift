//
//  Media.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

public struct Thumbnail {
    public let URL: String
    public let width: Int
    public let height: Int
    
    init(URL: String, width: Int, height: Int) {
        self.URL = URL
        self.width = width
        self.height = height
    }
}

public class Media: WistiaDataItem, WistiaCollectionItem {
    
    public var id: Int
    
    public var hashedId: String
    
    public var publicId: String
    
    public var name: String
    public var summary: String
    
    public var created: String
    public var updated: String
    
    public var section: String?
    public var status: String?
    public var progress: Float?
    
    // TODO: This probably doesnt need to be optional
    public var thumbnail: Thumbnail?
    
    public var assets: [Asset] = []
    
    public typealias T = Asset
    
    public var children: [T] {
        return assets
    }
    
    public init(id: Int, hashedId: String, publicId: String, name: String, summary: String, updated: String, created: String, assets: [Asset] = [], section: String? = nil, progress: Float? = nil, status: String? = nil, thumbnail: Thumbnail? = nil) {
        
        self.id = id
        self.hashedId = hashedId
        self.publicId = publicId
        
        
        self.name = name
        self.summary = summary
        
        self.updated = updated
        self.created = created
        
        self.section = section
        self.status = status
        self.progress = progress
        
        self.thumbnail = thumbnail
        
    }

}