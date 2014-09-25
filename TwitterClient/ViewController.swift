//
//  ViewController.swift
//  TwitterClient
//
//  Created by Franklin Ho on 9/24/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit
import Accounts
import Social


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var statusTableView: UITableView!
    
    
    
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    var statuses: [Status]?
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            NSLog("User info: \(notification.userInfo!)")
            let value = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
            let rect = value.CGRectValue()
            NSLog("Height: \(rect.size.height)")
            return ()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        statusTableView.delegate = self
        statusTableView.dataSource = self
        
        self.statusTableView.rowHeight = UITableViewAutomaticDimension
        
        let accountStore = ACAccountStore()
        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (success, error) in
            if success {
                let accounts = accountStore.accountsWithAccountType(accountType)
                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
                
                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: nil)
                
                authRequest.account = accounts[0] as ACAccount
                
                let request = authRequest.preparedURLRequest()
                
                let task = self.urlSession.dataTaskWithRequest(request,completionHandler: { (data, response, error) in
                    if error != nil {
                        NSLog("Error getting timeline")
                    } else {
                        let array = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
                        var statusArray:[Status] = Array()
                        for object in array {
                            let dictionary = object as NSDictionary
                            statusArray.append(Status(dictionary: dictionary))
                        }
                        dispatch_async(dispatch_get_main_queue(), {
                            self.statuses = statusArray
                            self.statusTableView.reloadData()
                        })
                        NSLog("Got dictionary: \(array)")
                    }
                })
                task.resume()
                
                NSLog("Accounts: \(accounts)")
            } else {
                NSLog("Error: \(error)")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StatusCell") as StatusTableViewCell
        let status = self.statuses![indexPath.row]
        println("Status text: \(status.text)")
        cell.statusLabel.text = status.text
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.statuses != nil {
            return self.statuses!.count
        } else {
            return 0
        }
    }

//    @IBAction func didTapNew(sender: AnyObject) {
//        let composer = ComposerViewController(nibName: nil, bundle: nil)
//        
//        self.navigationController?.presentViewController(composer, animated: true, completion: {
//            
//            })
//    }

}

