//
//  Networker.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

// MARK: Project Items Parsing

extension Project {
    
    
    /**
     
     Intilizer with JSON.
     
     - returns: Project?
     - parameter json: `[String: AnyObject]` The JSON for the project item.
     
     */
    public convenience init?(json: [String: AnyObject]) {
        guard let hashedId = json["hashedId"] as? String else { return nil }
        
        // TODO: Handle instances where "hashed_id" vs. "hashedId" is used in the API.
        
        let publicId = json["publicId"] as? String ?? ""
        let id = json["id"] as? Int ?? -1
        let mediaCount = json["mediaCount"] as? Int ?? 0
        let name = json["name"] as? String ?? ""
        let description = json["description"] as? String ?? ""
        let created = json["created"] as? String ?? ""
        let updated = json["updated"] as? String ?? ""
        
        let anonymousCanUpload = json["anonymousCanUpload"] as? Bool ?? false
        let anonymousCanDownload = json["anonymousCanDownload"] as? Bool ?? false
        
        self.init(id: id, hashedId: hashedId, publicId: publicId, name: name, summary: description, updated: updated, created: created, mediaCount: mediaCount, anonymousCanUpload: anonymousCanUpload, anonymousCanDownload: anonymousCanDownload)
        
        // Begin Adding Values that May Not Be Present in Various Contexts like "List" vs. "Show"
        if let mediaJSON = json["medias"] as? [[String: AnyObject]] {
            self.medias = mediaJSON.flatMap { Media(json: $0) }
        }
    }
    
}

// MARK: Media Items Parsing

extension Media {
    
    /// Optional Initializer from JSON
    public convenience init?(json: [String: AnyObject]) {
        guard let hashedId = json["hashedId"] as? String else { return nil }
        
        let publicId = json["publicId"] as? String ?? ""
        let id = json["id"] as? Int ?? -1
        let name = json["name"] as? String ?? ""
        let description = json["description"] as? String ?? ""
        let created = json["created"] as? String ?? ""
        let updated = json["updated"] as? String ?? ""

        
        self.init(id: id, hashedId: hashedId, publicId: publicId, name: name, summary: description, updated: updated, created: created)
        
        // Begin Adding Values that May Not Be Present in Various Contexts like "List" vs. "Show"
        if let assetJSON = json["assets"] as? [[String: AnyObject]] {
            self.assets = assetJSON.flatMap { Asset(json: $0) }
        }
        
    }
    
}

// MARK: Project Items Parsing

extension Asset {
    
    /// Optional Initializer from JSON
    public init?(json: [String: AnyObject]) {
        guard let URL = json["url"] as? String else { return nil }
        
        let type = json["type"] as? String ?? ""
        let contentType = json["contentType"] as? String ?? ""
        
        let width = json["width"] as? Int ?? 0
        let height = json["height"] as? Int ?? 0
        
        let fileSize = json["fileSize"] as? Int ?? 0
        
        self.init(URLString: URL, type: type, contentType: contentType, width: width, height: height, fileSize: fileSize)
    }
    
}