//
//  MeetingCreateViewController.swift
//  Cocoaheads
//
//  Created by Felix Wehnert on 15.01.15.
//  Copyright (c) 2015 Felix Wehnert. All rights reserved.
//

import UIKit

@objc protocol MeetingCreateViewDelegate {
    optional func didCreateNewMeeting(meeting: Meeting)
}

class MeetingCreateViewController: UIViewController, UITextFieldDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var summaryTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var location: Location?
    
    var delegate: MeetingCreateViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.datePicker.minimumDate = NSDate()
        
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
    
    @IBAction func create(sender: UIButton?) {
        
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
            meeting.saveInBackgroundWithBlock({ (saved, error) -> Void in
                if saved {
                    self.delegate?.didCreateNewMeeting?(meeting)
                }
            })
            
            
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func logInViewController(logInController: PFLogInViewController!, didFailToLogInWithError error: NSError!) {
        
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        logInController.dismissViewControllerAnimated(true, completion: nil)
        self.create(nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, shouldBeginLogInWithUsername username: String!, password: String!) -> Bool {
        return true
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController!) {
        
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        signUpController.dismissViewControllerAnimated(true, completion: nil)
        self.create(nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, shouldBeginSignUp info: [NSObject : AnyObject]!) -> Bool {
        return true
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didFailToSignUpWithError error: NSError!) {
        
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        
    }
    
    // MARK: - LoginViewControllerDelegate
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
