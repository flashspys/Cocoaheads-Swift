//
//  Meeting.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 15.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//

import UIKit

class Meeting: PFObject, PFSubclassing {
    
    @NSManaged var host: PFUser
    @NSManaged var location: Location
    @NSManaged var date: NSDate
    @NSManaged var summary: String
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Meeting"
    }
}
