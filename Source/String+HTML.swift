//
//  String+HTML.swift
//  WistiaKitDemo
//
//  Created by Jake Young on 3/25/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

extension String {
    
    public func stringByRemovingHTML() -> String {
        
        let regex:NSRegularExpression  = try! NSRegularExpression(
            pattern: "<.*?>",
            options: NSRegularExpressionOptions.CaseInsensitive)
        
        
        let range = NSMakeRange(0, self.characters.count)
        let htmlLessString :String = regex.stringByReplacingMatchesInString(self,
                                                                            options: NSMatchingOptions(),
                                                                            range:range ,
                                                                            withTemplate: "")
        return htmlLessString
    }
    
    public func stringByReplaceEncodedHTML() -> String {
        return self.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
    }
    
}