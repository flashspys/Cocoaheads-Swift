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
                let query = Location.query()
                query.limit = 1000
                query.whereKey("location", nearGeoPoint: geopoint)
                query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    if error == nil {
                        if let location = objects as? Array<Location> {
                            self.loadLocations(location)
                        }
                    } else {
                        if(error.code == kPFErrorCacheMiss) {
                            println("Parse Cache is not available. Waiting for online response!")
                        } else {
                            println("Parse data error: \(error.description)")
                        }
                    }
                })
            } else {
                println("Location not found: \(error.description)")
            }
        }
        
    }
    
    func loadLocations(locations: Array<Location>) {
        for location in locations {
            mapView.addAnnotation(location);
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

