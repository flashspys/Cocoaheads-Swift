//
//  MeetingQuery.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 10.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//

import UIKit

class MeetingQuery: PFQuery {
    
    override init() {
        super.init(className: "CocoaheadsMeeting")
        self.cachePolicy = kPFCachePolicyCacheThenNetwork
    }
    
}
