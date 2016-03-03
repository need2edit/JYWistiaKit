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
    
    convenience init?(json: [String: AnyObject?]) {
        guard let hashedId = json["hashedId"] as? String else { return nil }
        self.init(hashedId: hashedId)
    }
    
}

extension Media {
    
    convenience init?(json: [String: AnyObject?]) {
        guard let hashedId = json["hashedId"] as? String else { return nil }
        self.init(hashedId: hashedId)
    }
    
}