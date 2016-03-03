//
//  Networker.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

class Networking {
    
    
    
}

extension Project {
    
    convenience init?(json: [String: AnyObject]) {
        guard let hashedId = json["hashedId"] as? String else { return nil }
        
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
    }
    
}

extension Media {
    
    convenience init?(json: [String: AnyObject]) {
        guard let hashedId = json["hashedId"] as? String else { return nil }
        self.init(hashedId: hashedId)
    }
    
}

// MARK: URL Parameter Extension, Clever bit from Paw NSURLSession Extension

protocol URLQueryParameterStringConvertible {
    var queryParameters: String {get}
}

extension Dictionary : URLQueryParameterStringConvertible {
    /**
     This computed property returns a query parameters string from the given NSDictionary. For
     example, if the input is @{@"day":@"Tuesday", @"month":@"January"}, the output
     string will be @"day=Tuesday&month=January".
     @return The computed parameters string.
     */
    var queryParameters: String {
        var parts: [String] = []
        for (key, value) in self {
            let part = NSString(format: "%@=%@",
                String(key).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!,
                String(value).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!)
            parts.append(part as String)
        }
        return parts.joinWithSeparator("&")
    }
    
}

extension NSURL {
    /**
     Creates a new URL by adding the given query parameters.
     @param parametersDictionary The query parameter dictionary to add.
     @return A new NSURL.
     */
    func URLByAppendingQueryParameters(parametersDictionary : Dictionary<String, String>) -> NSURL {
        let URLString : NSString = NSString(format: "%@?%@", self.absoluteString, parametersDictionary.queryParameters)
        return NSURL(string: URLString as String)!
    }
}