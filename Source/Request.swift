//
//  Request.swift
//  WistiaKit
//
//  Created by Jake Young on 3/3/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

/// A request for an multiple Wistia Items, such as a Projects or Medias.
public enum WistiaCollectionRequestType: CustomStringConvertible {
    
    case Projects
    case Medias
    
    func request(page: Int = 1, per_page: Int = 10, sortDirection: SortDirection = .Ascending, sortBy: SortByDescriptor = .Updated) throws -> NSMutableURLRequest? {
        
        guard let apiKey = Wistia.API.apiKey where !apiKey.isEmpty else { throw Wistia.Error.EmptyAPIKey }
        guard var URL = Wistia.API.baseURL else { throw Wistia.Error.InvalidBaseURL }
        
        let endpoint: Wistia.Endpoint = (self == .Projects) ? .ListProjects : .ListMedias
        
        URL = URL.URLByAppendingPathComponent(endpoint.endpoint)
        
        let URLParams = [
            "page": "\(page)",
            "per_page": "\(per_page)",
            "sort_by": "\(sortBy.rawValue)",
            "sort_direction": "\(sortDirection.rawValue)",
            "api_password": "\(apiKey)",
            ]
        
        URL = URL.URLByAppendingQueryParameters(URLParams)
        
        
        let request = NSMutableURLRequest(URL: URL)
        return request
    }
    
    public var description: String {
        
        switch self {
            
        case .Projects:
            return "Requesting Projects"
        case .Medias:
            return "Requesting Medias"
            
        }
        
    }
}

/// A request for an individual Wistia Item, such as a Project or Media.
public enum WistiaItemRequestType: CustomStringConvertible {
    
    /// Single Request for Project by supplying a Hashed ID
    case Project(String)
    
    /// Single Request for Media by supplying a Hashed ID
    case Media(String)
    
    func request() throws -> NSMutableURLRequest? {
        
        guard let apiKey = Wistia.API.apiKey where !apiKey.isEmpty else { throw Wistia.Error.EmptyAPIKey }
        guard var URL = Wistia.API.baseURL else { throw Wistia.Error.InvalidBaseURL }
        
        
        switch self {
            
        case .Project(let hashedId):
            URL = URL.URLByAppendingPathComponent(Wistia.Endpoint.ShowProject(hashedId: hashedId).endpoint)
        case .Media(let hashedId):
            URL = URL.URLByAppendingPathComponent(Wistia.Endpoint.ShowMedia(hashedId: hashedId).endpoint)
        }
        
        print(URL)
        
        let URLParams = [
            "api_password": "\(apiKey)",
            ]
        
        URL = URL.URLByAppendingQueryParameters(URLParams)
        
        
        let request = NSMutableURLRequest(URL: URL)
        return request
    }
    
    public var description: String {
        
        switch self {
            
        case .Project(let hashedId):
            return "Requesting Project with Hashed ID: \(hashedId)"
        case .Media(let hashedId):
            return "Requesting Media with Hashed ID: \(hashedId)"
            
        }
        
    }
    
}

 /**
 
 The name of the field to sort by. Valid values are name, mediaCount, created, or updated. Defaults to sorting by Project ID.

 */
public enum SortByDescriptor: String {
    case Name = "name"
    case MediaCount = "mediaCount"
    case Created = "created"
    case Updated = "updated"
}

/**
 
 Specifies the direction of the sort, defaults to '1'. 1 = ascending, 0 = descending.
 
 */

public enum SortDirection: Int {
    case Ascending = 1
    case Descending = 0
}

/**
 
 You can get your results back in chunks. In order to set the page size and/or the number of pages that you want to see, use the following query parameters:
 
  - Parameters:
      - page: Specifies which page of the results you want to see. Defaults to 1 (not 0).
      - perPage: The number of results you want to get back per request. The maximum value of this parameter is 100. Defaults to 10.
 
*/

protocol SupportsPaging {
    
    /// Specifies which page of the results you want to see. Defaults to 1 (not 0).
    var page: Int { get set }
    var per_page: Int { get set }
    
}

/**
 
 You can get your results back in chunks. In order to set the page size and/or the number of pages that you want to see, use the following query parameters:
 
 - Parameters:
    - sortBy: The name of the field to sort by. Valid values are name, mediaCount, created, or updated. Defaults to sorting by Project ID.
    - sortDirection: Specifies the direction of the sort, defaults to '1'. 1 = ascending, 0 = descending.
 
 */

protocol SupportsSorting {
    
    /// Specifies which page of the results you want to see. Defaults to 1 (not 0).
    var sortBy: SortByDescriptor { get set }
    
    // Specifies the direction of the sort, defaults to '1'. 1 = ascending, 0 = descending.
    var sortDirection: SortDirection { get set }
    
}

protocol WistiaMethod {
    
    /// Wistia Methods My Provide Query Parameters
    var queryParams: String? { get }
    
}

/**
 
 **Paging and Sorting Responses**
 
 The list methods in the API support paging, sorting, and filtering of results. Filtering will be covered in the individual methods.
 
**Paging**
 
 You can get your results back in chunks. In order to set the page size and/or the number of pages that you want to see, use the following query parameters:
 
 - Parameters:
    - page: Specifies which page of the results you want to see. Defaults to 1 (not 0).
    - perPage: The number of results you want to get back per request. The maximum value of this parameter is 100. Defaults to 10.
 
 **Sorting**
 
 You can sort the results you receive based on a field you specify. To specify how you want the results to be sorted, append one or both of the following query parameters to the request URL:
 
 - Parameters:
    - sortBy: The name of the field to sort by. Valid values are name, mediaCount, created, or updated. Defaults to sorting by Project ID.
    - sortDirection: Specifies the direction of the sort, defaults to '1'. 1 = ascending, 0 = descending.
 
 For example, if you want to sort your results in descending order by the date created, your request URL would look something like this:
 
 ```swift
 
    https://api.wistia.com/v1/projects.json?sort_by=created&sort_direction=0
 
 ```
 
*/

protocol WistiaListMethod: SupportsPaging, SupportsSorting {
    
}