//
//  ListViewController.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 10.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//
import UIKit

class ListViewController: PFQueryTableViewController {
    
    var currentLocation: PFGeoPoint?
    
    override func queryForTable() -> PFQuery! {
        let query = LocationQuery()
        query.whereKey("location", nearGeoPoint: currentLocation)
        return query
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        self.parseClassName = "Location"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    func callSuperDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLoad() {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint: PFGeoPoint?, error: NSError?) -> Void in
            self.currentLocation = geopoint
            self.callSuperDidLoad() // looks dirty. but is not dirty
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        super.tableView(tableView, cellForRowAtIndexPath: indexPath, object: object)
        
        let cellIdentifier = "cellIdentifier"
        
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if (cell == nil) {
            cell = PFTableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellIdentifier)
        }
        
        
        cell?.textLabel?.text = (object["name"] as String)
        
        let distance = String(format: "%.2f", (object["location"] as PFGeoPoint).distanceInKilometersTo(self.currentLocation))
        cell?.detailTextLabel?.text = "\(distance) km"

        return cell as PFTableViewCell
        
    }
    
    override func objectsWillLoad() {
        super.objectsWillLoad()
        println("Objects will load")
    }
    
    override func objectsDidLoad(error: NSError!) {
        super.objectsDidLoad(error)
        if error != nil {
            println("Objects loaded with error: \(error.description)")
        } else {
            println("Objects loaded")
        }
    }
}
