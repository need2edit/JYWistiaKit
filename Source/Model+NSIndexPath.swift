//
//  Project+NSIndexPath.swift
//  WistiaKit
//
//  Created by Jake Young on 4/15/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

public protocol WistiaProjectDataSource {
    
    var sections: [String] { get }
    
    func sectionTitleAtIndexPath(indexPath: NSIndexPath) -> String?
    func itemsForSection(section: Int) -> [Media]?
    func itemsForSection(sectionTitle: String) -> [Media]?
    func itemAtIndexPath(indexPath: NSIndexPath) -> Media?
    
}

extension Project: WistiaProjectDataSource {
    
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
}


extension SimpleDataSource {
    
    public func itemAtIndexPath(indexPath: NSIndexPath) -> Media? {
        return sections[indexPath.section].medias[indexPath.row]
    }
    
}