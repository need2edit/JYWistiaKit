//
//  NSURL+QueryParams.swift
//  WistiaKit
//
//  Created by Jake Young on 3/3/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

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