//
//  Project.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

/**
 
 **Projects** are the main organizational objects within Wistia. Media must be stored within Projects.
 
 When a **Project Object** is returned from a method, it will include the following fields:
 
 - returns: Project?
 - parameter id: `Int` A unique numeric identifier for the project within the system.
 - parameter name: `String` The project's display name.
 - parameter summary: `String` The project's description. Renamed to summary since description is reserved with `CustomStringConvertible`.
 - parameter created: `String` The date that the project was originally created.
 - parameter updated: `String` The date that the project was last updated.
 - parameter hashedId: `String` A private hashed id, uniquely identifying the project within the system.
 - parameter anonymousCanUpload: `Boolean` A boolean indicating whether or not anonymous uploads are enabled for the project.
 - parameter anonymousCanDownload: `Boolean` A unique numeric identifier for the project within the system.
 - parameter viewingIsPublic: `Boolean` A boolean indicating whether the project is available for public (anonymous) viewing.  Because public is a reserved keyword in Swift, renaming this for clarity.
 - parameter publicId: `String` If the project is public, this field contains a string representing the ID used for referencing the project in public URLs.

*/
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
    
    public var medias: [Media]?
    
    /**
     
     **Projects** are the main organizational objects within Wistia. Media must be stored within Projects.
     
     When a **Project Object** is returned from a method, it will include the following fields:
     
     - returns: Project?
     - parameter id: `Int` A unique numeric identifier for the project within the system.
     - parameter name: `String` The project's display name.
     - parameter summary: `String` The project's description. Renamed to summary since description is reserved with `CustomStringConvertible`.
     - parameter created: `String` The date that the project was originally created.
     - parameter updated: `String` The date that the project was last updated.
     - parameter hashedId: `String` A private hashed id, uniquely identifying the project within the system.
     - parameter anonymousCanUpload: `Boolean` A boolean indicating whether or not anonymous uploads are enabled for the project.
     - parameter anonymousCanDownload: `Boolean` A unique numeric identifier for the project within the system.
     - parameter viewingIsPublic: `Boolean` A boolean indicating whether the project is available for public (anonymous) viewing.  Because public is a reserved keyword in Swift, renaming this for clarity.
     - parameter publicId: `String` If the project is public, this field contains a string representing the ID used for referencing the project in public URLs.
     
     */
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