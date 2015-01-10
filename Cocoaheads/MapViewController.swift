//
//  ViewController.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 06.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//

import UIKit

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
            if (error == nil) {
                let query = MeetingQuery()
                query.whereKey("Location", nearGeoPoint: geopoint)
                query.limit = 1000;
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    if error == nil {
                        if let meetings = objects as? Array<PFObject> {
                            self.loadLocations(meetings)
                        }
                    } else {
                        println("Location not found: \(error.description)")
                    }
                })
            }
        }
        
        
    }
    
    func loadLocations(locations: Array<PFObject>) {
        for meeting in locations {
            let annotation = MapAnnotation(meeting: meeting)
            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "MapAnnotation")
            annotationView.centerOffset = CGPointMake(10, -20)
            mapView.addAnnotation(annotation);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

