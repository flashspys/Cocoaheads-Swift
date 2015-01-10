//
//  MapAnnotation.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 06.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//

import Foundation

class MapAnnotation : NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String
    var subtitle: String
    
    init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
    
    convenience init(meeting: PFObject) {
        let coordinate = CLLocationCoordinate2D(latitude: meeting["Location"].latitude, longitude: meeting["Location"].longitude)
        self.init(coordinate: coordinate, title: meeting["Name"] as String, subtitle: "")
    }
}