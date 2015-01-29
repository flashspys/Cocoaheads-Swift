//
//  Location.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 15.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//

import UIKit

class Location: PFObject, PFSubclassing, MKAnnotation {
    
    // MKAnnotation override
    
    var title: String {
        get {
            return self.name;
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(self["location"].latitude, self["location"].longitude)
        }
    }
    
    @NSManaged var name: String
    @NSManaged var location: PFGeoPoint
    
    override class func load() {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String! {
        return "Location"
    }
    
    
    
}
