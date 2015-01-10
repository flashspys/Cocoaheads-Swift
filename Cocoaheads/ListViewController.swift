//
//  ListViewController.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 10.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//
import UIKit

class ListViewController: PFQueryTableViewController {
    
    override func queryForTable() -> PFQuery! {
        let query = MeetingQuery()
        
        return query
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        self.parseClassName = "CocoaheadsMeeting"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(UIApplication.sharedApplication().statusBarFrame.height, 0, (self.tabBarController?.tabBar.frame.height)!-1, 0)
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {
        super.tableView(tableView, cellForRowAtIndexPath: indexPath, object: object)
        
        let cellIdentifier = "cellIdentifier"
        
        var cell: AnyObject? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)
        if cell == nil {
            cell = PFTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        if let lbl: UILabel = cell?.textLabel {
            lbl.text = (object["Name"] as String)
        }

        return cell as PFTableViewCell
        
    }
    
    override func objectsWillLoad() {
        super.objectsWillLoad()
        println("Objects will load")
    }
    
    override func objectsDidLoad(error: NSError!) {
        super.objectsDidLoad(error)
        if error != nil {
            println("Objects loaded: \(error.description)")
        } else {
            println("Objects loaded")
        }
    }
}
