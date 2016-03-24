//
//  AssetURLs.swift
//  WistiaKit
//
//  Created by Jake Young on 3/24/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

extension NSURL {
    
    /**
    Asset URLs in Wistia take this form:
    
    `http://embed.wistia.com/deliveries/43500c9644e43068d8995dcb5ddea82440419eaf.bin`
 
     - parameter filename: The desired filename.
     - parameter fileExtension: The desired extension for the file.
     
     - returns: Sed do eiusmod tempor.
    */
    public func wistiaURLString(filename filename: String = "", fileExtension: String = "bin") -> NSURL {
        
        if filename.isEmpty {
            return self
        }
        
        // TODO: Maybe theres a pure Swift way to do this, but NSString
        guard let originalString = self.path else {
            return self
        }
        
        let path = originalString as NSString
        let baselineURL = path.stringByDeletingPathExtension
        
        
        let URLString = "\(baselineURL)\(filename)\(fileExtension)"
        
        guard let URL = NSURL(string: URLString) else {
            return self
        }
        
        return URL
    }
    
}