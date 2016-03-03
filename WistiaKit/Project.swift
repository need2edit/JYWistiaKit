//
//  Project.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

public class Project: WistiaDataItem {
    
    public var id: Int
    
    public var hashedId: String
    
    public var publicId: String
    
    public var name: String
    public var summary: String
    
    public var mediaCount: Int
    
    public var anonymousCanUpload: Bool
    public var anonymousCanDownload: Bool
    
    public var created: String
    public var updated: String
    
    public init(id: Int, hashedId: String, publicId: String, name: String, summary: String, updated: String, created: String, mediaCount: Int, anonymousCanUpload: Bool = false, anonymousCanDownload: Bool = false) {
        
        self.id = id
        self.hashedId = hashedId
        self.publicId = publicId
        
        
        self.name = name
        self.summary = summary
        
        self.mediaCount = mediaCount
        
        self.anonymousCanUpload = anonymousCanUpload
        self.anonymousCanDownload = anonymousCanDownload
        
        self.updated = updated
        self.created = created
    }
    
    public var description: String {
        return "Project: \(self.name)\nDescription:\(self.summary)"
    }
}