//
//  String+Courses.swift
//  WistiaKitDemo
//
//  Created by Jake Young on 3/25/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

extension String {
    
    public func removeNumberPrefix() -> String {
        
        
        let whitespaceAndPunctuationSet = NSMutableCharacterSet(charactersInString: ".")
        whitespaceAndPunctuationSet.formUnionWithCharacterSet(NSCharacterSet.decimalDigitCharacterSet())
        
        let stringScanner = NSScanner(string: self)
        
        stringScanner.charactersToBeSkipped = whitespaceAndPunctuationSet
        
        var name: NSString?
        while stringScanner.scanUpToCharactersFromSet(whitespaceAndPunctuationSet, intoString: &name), let name = name
        {
            return name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
        
        return self
    }
    
}