//
//  MeetingCreateViewController.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 15.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//

import UIKit

class MeetingCreateViewController: UIViewController, UITextFieldDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var summaryTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var location: Location?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: "endEditing:"))
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geopoint, error) -> Void in
            let query = Location.query()
            query.whereKey("location", nearGeoPoint: geopoint)
            query.limit = 1
            query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                self.location = object as? Location
                self.locationLabel.text = "Location: \(self.location!.name)"
            })
            
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func create(sender: UIButton) {
        
        if PFUser.currentUser() == nil {
            
            
            let logInViewController = PFLogInViewController()
            logInViewController.delegate = self
            
            let signUpViewController = PFSignUpViewController()
            signUpViewController.delegate = self
            
            logInViewController.signUpController = signUpViewController
            
            self.presentViewController(logInViewController, animated: true, completion: nil)
            
        } else {
            // Create new Meeting Object
            let meeting = Meeting()
            meeting.summary = summaryTextField.text
            meeting.host = PFUser.currentUser()
            meeting.location = self.location!
            meeting.date = self.datePicker.date
            // Save
            meeting.saveInBackground()
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
