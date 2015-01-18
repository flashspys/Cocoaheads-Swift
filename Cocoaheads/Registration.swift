//
//  Registration.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 18.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//

import UIKit

class Registration: PFObject, PFSubclassing {
    @NSManaged var user : PFUser
    @NSManaged var meeting : Meeting
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String {
        return "Registration"
    }
    
}
