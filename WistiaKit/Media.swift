//
//  Media.swift
//  WistiaKit
//
//  Created by Jake Young on 3/2/16.
//  Copyright © 2016 Jake Young. All rights reserved.
//

import Foundation

public class Media: WistiaDataItem {
    
    public var hashedId: String
    
    public init(hashedId: String) {
        self.hashedId = hashedId
    }
}