//
//  MeetingQuery.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 10.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//

import UIKit

class LocationQuery: PFQuery {
    
    override init() {
        super.init(className: "Location")
        self.cachePolicy = kPFCachePolicyCacheThenNetwork
        self.limit = 1000 // 1000 is max limit
    }
    
}
