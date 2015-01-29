//
//  MeetingListViewController.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 10.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//
import UIKit

class MeetingListViewController: PFQueryTableViewController, MeetingCreateViewDelegate {
    
    
    
    override func queryForTable() -> PFQuery! {
        let query = Meeting.query()
        query.limit = 1000
        query.whereKey("date", greaterThanOrEqualTo: NSDate())
        query.orderByDescending("date")
        query.includeKey("location")
        return query
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Meeting"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!, object: PFObject!) -> PFTableViewCell! {

        let meeting = object as Meeting
        
        let cellIdentifier = "meetingCellIdentifier"
        
        var cell: MeetingTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MeetingTableViewCell
        if (cell == nil) {
            cell = MeetingTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        cell?.label?.text = meeting.summary
        
        var detailedLabelText: String = dateFormatter.stringFromDate(meeting.date)
        detailedLabelText += " in " + meeting.location.name
        
        cell?.detailLabel?.text = detailedLabelText
        
        var query = Registration.query()
        query.whereKey("meeting", equalTo: meeting)
        query.countObjectsInBackgroundWithBlock { (numOfRegistrations, error) -> Void in
            let cnt = String(numOfRegistrations) // otherwise swift compiler will fail
            cell?.countLabel?.text = cnt
        }

        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let alertController = UIAlertController(title: "Sign up for Meeting?", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        alertController.addAction(UIAlertAction(title: "Sign up", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let meeting = self.objectAtIndexPath(indexPath) as Meeting
            if PFUser.currentUser() != nil {
                let registration = Registration()
                registration.user = PFUser.currentUser()
                registration.meeting = meeting
                registration.saveEventually({ (saved, error) -> Void in
                    let string = ""
                    self.tableView.reloadData()
                })
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
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
    
    // MeetingCreateViewDelegate
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addMeetingSegue" {
            let meetingCreateViewController = segue.destinationViewController as MeetingCreateViewController
            meetingCreateViewController.delegate = self
        }
    }
    
    func didCreateNewMeeting(meeting: Meeting) {
        self.loadObjects()
    }
}
