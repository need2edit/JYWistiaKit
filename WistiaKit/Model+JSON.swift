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
    
     /**
     
     Optional convenience Initializer for Media items from JSON.
     
     Media items will have more or less information provided depending on the requesting context. If you list Media items in a project, you wont get the assets and other info needed for playback. This intilizier works with both scenarios, treating properties that dont show up in a Project's media list response as optional.
     
     - returns: Project?
     
     Parameters:
     - json: [String: AnyObject] the JSON as a dictionary object used to create the media item.
     
     */
    public convenience init?(json: [String: AnyObject]) {
        guard let hashedId = json["hashedId"] as? String else { return nil }
        
        // TODO: Handle instances where "hashed_id" vs. "hashedId" is used in the API.
        
        let publicId = json["publicId"] as? String ?? ""
        let viewingIsPublic = json["public"] as? Bool ?? false
        let id = json["id"] as? Int ?? -1
        let mediaCount = json["mediaCount"] as? Int ?? 0
        let name = json["name"] as? String ?? ""
        let description = json["description"] as? String ?? ""
        let created = json["created"] as? String ?? ""
        let updated = json["updated"] as? String ?? ""
        
        let anonymousCanUpload = json["anonymousCanUpload"] as? Bool ?? false
        let anonymousCanDownload = json["anonymousCanDownload"] as? Bool ?? false
        
        self.init(id: id, hashedId: hashedId, publicId: publicId, name: name, summary: description, updated: updated, created: created, mediaCount: mediaCount, anonymousCanUpload: anonymousCanUpload, anonymousCanDownload: anonymousCanDownload, viewingIsPublic: viewingIsPublic)
        
        // Begin Adding Values that May Not Be Present in Various Contexts like "List" vs. "Show"
        if let mediaJSON = json["medias"] as? [[String: AnyObject]] {
            self.medias = mediaJSON.flatMap { Media(json: $0) }.sort({ (lhs, rhs) -> Bool in
                lhs.name < rhs.name
            })
        }
    }
    
}

extension Thumbnail {

    /**
     
     Optional convenience Initializer for a Thumbnail in the Media response.
     
     Parameters:
     - json: [String: AnyObject] the JSON as a dictionary object used to create the thumbnail item.
     
     */
    public init?(json: [String: AnyObject]) {
        guard let URL = json["url"] as? String, width = json["width"] as? Int, height = json["height"] as? Int else { return nil }
        self.init(URL: URL, width: width, height: height)
    }

}

// MARK: Media Items Parsing

extension Media {
    
    /**

     Optional convenience Initializer for Media items from JSON.
     
     Media items will have more or less information provided depending on the requesting context. If you list Media items in a project, you wont get the assets and other info needed for playback. This intilizier works with both scenarios, treating properties that dont show up in a Project's media list response as optional.
     
     Parameters: 
        - json: [String: AnyObject] the JSON as a dictionary object used to create the media item.
    
    */
    public convenience init?(json: [String: AnyObject]) {
        
        guard let hashedId = json["hashedId"] as? String ?? json["hashed_id"] as? String else { return nil }
        
        let publicId = json["publicId"] as? String ?? ""
        let id = json["id"] as? Int ?? -1
        let name = json["name"] as? String ?? ""
        let description = json["description"] as? String ?? ""
        let created = json["created"] as? String ?? ""
        let updated = json["updated"] as? String ?? ""
        
        let section = json["section"] as? String
        
        let status = json["status"] as? String
        
        let progress = json["progress"] as? Float ?? 1.0
        
        let thumbnailJSON = json["thumbnail"] as? [String: AnyObject]
        
        self.init(id: id, hashedId: hashedId, publicId: publicId, name: name, summary: description, updated: updated, created: created, assets: [], section: section, progress: progress, status: status, thumbnail: nil)
        
        if let thumbnailJSON = thumbnailJSON, thumbnail = Thumbnail(json: thumbnailJSON) {
            self.thumbnail = thumbnail
        }
        
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