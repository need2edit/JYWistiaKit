//
//  DataSource.swift
//  WistiaKit
//
//  Created by Jake Young on 3/4/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

#if os(iOS)
    import UIKit
#elseif os(watchOS)
    import UIKit
#elseif os(tvOS)
    import UIKit
#elseif os(OSX)
    import Cocoa
#endif

/**
 
Section structs help capture the behavior of Wistia Project items and simple data tasks like working with Tables and Grids. 
 
 **Need a title for your section?** No problem.
 
 **Need the items pre-parsed for that section title?** Got you covered.:
 
 - Parameters:
    - title: An optional name for the section.
    - medias: The items related to this section.
 
 */

public struct Section {
    
    /// An optional name for the section.
    public let title: String?
    
    /// The items related to this section.
    public let medias: [Media]
}

extension Section: Equatable {}

// MARK: Equatable

public func ==(lhs: Section, rhs: Section) -> Bool {
    // Naïve equality that uses string comparison rather than resolving equivalent selectors
    return lhs.title == rhs.title
}

extension Section: Comparable {}

// MARK: Comparable

public func <(lhs: Section, rhs: Section) -> Bool {
    return lhs.title < rhs.title
}

/**

`SimpleDataSource` objects are designed to encapsulate the behavior of Wistia Projects.

 Creating an object like this is designed to simplify parsing and setup of the Section > Medias relationships within Wistia.
 
 There are a few goodies. Wistia Projects may have objects in an empty section, which depending on how you plan to organize your content, you may want to hide items that havent been assigned a section.  As an example, you might be reviewing some content as a team, but not yet ready for a customer to see it.  Once a media is moved into a section, it becomes visible.
 
 Simple Data Sources support the following:
 
 - Parameters:
    - name: An optional name for the data source.  For example the title on a view controller, or section you need to select.
    - items: All the items within the data source
    - sections: A complex grouping of items built from the original project.
 
*/
public class SimpleDataSource {
    
    public typealias T = Media
    
    /// An optional name for the data source.  For example the title on a view controller, or section you need to select.
    public var name: String?
    
    /// All the items within the data source
    public var items: [T] = []
    
    /// A complex grouping of items built from the original project.
    public var sections: [Section] = []
    
    public func sectionForIndexPath(section: Int) -> String? {
        return sections[section].title
    }
    
    public func itemsForSection(sectionTitle: String?) -> [Media] {
        return items.filter { $0.section == sectionTitle }
    }
    
    // TODO: This could work for media items as well, refactor to a protocol when you have time and apply it to just a Parent > Children tree modeling.
    
    /**
    
    Form a simple data source with a Project item.
    
    Designed to work well with Tables and Grids or for importing into Core Data.
    
    - Parameters:
    - project: The Wistia project you would like to form the data item from.
    - showsEmptySection: Wether or not to show the empty section of items characteristic of Wistia Projects.
    
    */
    public init?(project: Project, showsEmptySection: Bool = false) {
        
        self.name = project.name
        guard let items = project.medias else { return nil }
        self.items = items
        
        let titles = items.map { $0.section }
        let uniqueTitles = Set<String>(titles.flatMap {$0 })
        
        var allSections: [String?] = [nil]
        for title in uniqueTitles {
            allSections.append(title)
        }
        if showsEmptySection {
            self.sections = allSections.flatMap { Section(title: $0, medias: itemsForSection($0)) }.sort(<)
        } else {
            self.sections = uniqueTitles.flatMap { Section(title: $0, medias: itemsForSection($0)) }.sort(<)
        }
        
    }
    
}

extension SimpleDataSource: CustomStringConvertible {
    public var description: String {
        
        if let descriptionName = name {
            return "Name: \(descriptionName)\nNumber Of Sections: \(sections.count)"
        }
        
        return "No Description"
        
    }
}

/**
 
 `ComplexDataSource` objects are designed to compose more complex data graphs.
 
 It is essentially a group of SimpleDataSources so you could create an app with multiple Wistia projects instead of just one.
 
Complex Data Sources support the following:
 
 - Parameters:
 - sections: The names of the simple data sources in this composition.
 - items: A group of SimpleDataSources.
 
 */
class ComplexDataSource {
    
    /// The names of the simple data sources in this composition.
    var sections: [String?] {
        return items.map { $0.name }
    }
    
    /// A complex grouping of items built from the original project.
    var items: [SimpleDataSource] = []
    
    
}