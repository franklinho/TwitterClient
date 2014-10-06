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


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ComposerViewControllerDelegate {
    @IBOutlet weak var statusTableView: UITableView!
    
    // Pull to refresh
    var refreshControl : UIRefreshControl!
    
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    var statuses: NSMutableArray = []
    
    var timelineStyle : String!
    
    // Indicates offset for infinite scrolling
    var currentMaxStatusID:String?
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserverForName(UIKeyboardWillShowNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification) -> Void in
            NSLog("User info: \(notification.userInfo!)")
            let value = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
            let rect = value.CGRectValue()
            NSLog("Height: \(rect.size.height)")
            return ()
        }
        self.statusTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.timelineStyle = (self.navigationController? as TwitterNavigationController).timelineStyle

        
        // Styles navigation bar
        navigationController?.navigationBar.barTintColor = UIColor(red: 90/255.0, green: 200/255.0, blue: 250/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = UIColor(red: 90/255.0, green: 200/255.0, blue: 250/255.0, alpha: 1.0)
        self.navigationItem.title = "Home"

        // Sets tableview delegate and datasource
        statusTableView.delegate = self
        statusTableView.dataSource = self
        
        // Sets autolayout dynamic height for rows
        self.statusTableView.rowHeight = UITableViewAutomaticDimension
        
        
        // Add pull to refresh to the tableview
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "requestStatuses:maxStatusID:", forControlEvents: UIControlEvents.ValueChanged)
        self.statusTableView.addSubview(refreshControl)
        
        // Ask for Statuses
        self.requestStatuses(self, maxStatusID: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Updates each cell with status labels
        let cell = tableView.dequeueReusableCellWithIdentifier("StatusCell") as StatusTableViewCell
        let status = self.statuses[indexPath.row] as Status
        cell.updateLabelsWithStatus(status)
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.statuses.count > 0 {
            return self.statuses.count
        } else {
            return 0
        }
    }

    
    func requestStatuses(sender: AnyObject, maxStatusID: String?) {

        var requestParams = ["count":"20"]
        if maxStatusID == nil {
            self.currentMaxStatusID = nil
            self.statuses = []
        } else {
            requestParams["max_id"] = maxStatusID
        }
        
        // Get home timeline tweets
        if(self.timelineStyle == "Home") {
            TwitterClient.sharedInstance.homeTimelineWithParams(requestParams, completion: { (statuses, error) -> () in
                dispatch_async(dispatch_get_main_queue(),{
                    if (statuses != nil) {
                        self.statuses.addObjectsFromArray(statuses!)
                        self.currentMaxStatusID = (self.statuses[self.statuses.count-1] as Status).statusID
                        self.refreshControl.endRefreshing()
                        self.statusTableView.reloadData()
                    }
                    
                })
                
            })
        } else if (self.timelineStyle == "Mentions"){
            TwitterClient.sharedInstance.mentionTimelineWithParams(requestParams, completion: { (statuses, error) -> () in
                dispatch_async(dispatch_get_main_queue(),{
                    if (statuses != nil) {
                        self.statuses.addObjectsFromArray(statuses!)
                        self.currentMaxStatusID = (self.statuses[self.statuses.count-1] as Status).statusID
                        self.refreshControl.endRefreshing()
                        self.statusTableView.reloadData()
                    }
                    
                })
                
            })
        }
        //        let accountStore = ACAccountStore()
        //        let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)
        //        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (success, error) in
        //            if success {
        //                let accounts = accountStore.accountsWithAccountType(accountType)
        //                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
        //
        //                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: nil)
        //
        //
        //                if accounts.count > 0 {
        //                    authRequest.account = accounts[0] as ACAccount
        //
        //                    let request = authRequest.preparedURLRequest()
        //
        //                    let task = self.urlSession.dataTaskWithRequest(request,completionHandler: { (data, response, error) in
        //                        if error != nil {
        //                            NSLog("Error getting timeline")
        //                        } else {
        //                            let array = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as [NSDictionary]
        //                            var statusArray:[Status] = Status.statusesWithArray(array)
        //                            self.refreshControl.endRefreshing()
        //                            dispatch_async(dispatch_get_main_queue(), {
        //                                self.statuses = statusArray
        //
        //                                self.statusTableView.reloadData()
        //
        //                            })
        //                            //                        NSLog("Got dictionary: \(array)")
        //                        }
        //                    })
        //                    task.resume()
        //                }
        //                
        //                
        //                
        //                NSLog("Accounts: \(accounts)")
        //            } else {
        //                NSLog("Error: \(error)")
        //            }
        //        }
        //
    }
    
    // Passes status data to statusDetailViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StatusDetailSegue") {
            // Pass status object to statusDetailViewControlle
            var statusDetailController : StatusDetailViewController = segue.destinationViewController as StatusDetailViewController
            var statusIndex = statusTableView!.indexPathForSelectedRow()?.row
            statusDetailController.status = self.statuses[statusIndex!] as Status
        } else if (segue.identifier == "profileSegue") {
            var point : CGPoint = sender!.locationInView(self.statusTableView)
            var indexPath : NSIndexPath = self.statusTableView.indexPathForRowAtPoint(point)!
            println("IndexPath: \(indexPath)")
//
            var profileController: ProfileViewController = segue.destinationViewController as ProfileViewController
            var statusIndex = indexPath.row
            profileController.userName = (self.statuses[statusIndex] as Status).screenName
            println("ProfileUsername: \(profileController.userName)")
//
        }
    }
    
    // Logs user out
    @IBAction func logOutButtonPressed(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    // Implements scrolling. Checks if current position of tableview is at the contentHeight position. If so, add businesses to tableView.
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
        var actualPosition :CGFloat = scrollView.contentOffset.y
        var contentHeight : CGFloat = scrollView.contentSize.height - 550
        
//        println("Actual Position: \(actualPosition), Content Height: \(contentHeight)")
        if (statuses.count > 0 && actualPosition >= contentHeight) {
            requestStatuses(self, maxStatusID: self.currentMaxStatusID)
            self.statusTableView.reloadData()
        }
        
    }
    
    func didFinishComposingStatus(statusText: String) {
        println("Composition complete: \(statusText)")
    }


}