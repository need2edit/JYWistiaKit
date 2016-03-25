//
//  Project.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

protocol WistiaProjectDataSource {
    
    var sections: [String] { get }
    
    func sectionTitleAtIndexPath(indexPath: NSIndexPath) -> String?
    func itemsForSection(section: Int) -> [Media]?
    func itemsForSection(sectionTitle: String) -> [Media]?
    func itemAtIndexPath(indexPath: NSIndexPath) -> Media?
    
}

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
public class Project: WistiaDataItem, WistiaCollectionItem, WistiaProjectDataSource {
    
    public var id: Int
    
    public var hashedId: String
    
    public var publicId: String
    public var viewingIsPublic: Bool
    
    public var name: String
    public var summary: String
    
    public var mediaCount: Int
    
    public var anonymousCanUpload: Bool
    public var anonymousCanDownload: Bool
    
    public var created: String
    public var updated: String
    
    public var medias: [Media]?
    
    public var sections: [String] {
        
        // FIXME: The way this is setup right now doesnt allow for nil values
        
        // TODO: I never feel good about this, but it works like a charm
        guard let medias = medias else { return [] }
        let allSections = medias.flatMap { $0.section }
        let uniqueSections = Set<String>(allSections)
        
        return Array(uniqueSections).sort(<)
        
        
    }
    
    public func sectionTitleAtIndexPath(indexPath: NSIndexPath) -> String? {
        return sections[indexPath.section]
    }
    
    public func itemsForSection(sectionTitle: String) -> [Media]? {
        return medias?.filter( { $0.section == sectionTitle })
    }
    
    public func itemsForSection(section: Int) -> [Media]? {
        let sectionTitle = sections[section]
        return itemsForSection(sectionTitle)
    }
    
    public func itemAtIndexPath(indexPath: NSIndexPath) -> Media? {
        
        return itemsForSection(indexPath.section)?[indexPath.row]
        
    }
    
    
    public typealias T = Media
    
    public var children: [T] {
        return medias ?? []
    }
    
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
     - parameter publicId: `String` If the project is public, this field contains a string representing the ID used for referencing the project in public URLs.
     - parameter viewingIsPublic: `Boolean` A boolean indicating whether the project is available for public (anonymous) viewing.  Because public is a reserved keyword in Swift, renaming this for clarity.
     
     */
    public init(id: Int, hashedId: String, publicId: String, name: String, summary: String, updated: String, created: String, mediaCount: Int, anonymousCanUpload: Bool = false, anonymousCanDownload: Bool = false, viewingIsPublic: Bool = false) {
        
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
        
        self.viewingIsPublic = viewingIsPublic
        
    }
    
    public var description: String {
        return "Project: \(self.name)\nDescription:\(self.summary)"
    }
}