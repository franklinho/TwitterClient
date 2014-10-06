//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Franklin Ho on 9/30/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var user: User!
    var statuses: NSMutableArray = []
    // Pull to refresh
    var refreshControl : UIRefreshControl!
    
    
    var userName:String?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusTableView: UITableView!
    // Indicates offset for infinite scrolling
    var currentMaxStatusID:String?
    
    func requestStatuses(sender: AnyObject, maxStatusID: String?) {
        
        var requestParams = ["count":"20"]
        requestParams["screen_name"] = self.userName
        if maxStatusID == nil {
            self.currentMaxStatusID = nil
            self.statuses = []
        } else {
            requestParams["max_id"] = maxStatusID
        }
        
        // Get timeline tweets
        TwitterClient.sharedInstance.userTimeLineWithParams(requestParams, completion: { (statuses, error) -> () in
            dispatch_async(dispatch_get_main_queue(),{
                if (statuses != nil) {
                    self.statuses.addObjectsFromArray(statuses!)
//                    println("Statuses: \(self.statuses)")
//                    println("Last Status ID: \((self.statuses[self.statuses.count-1] as Status).statusID)")
                    self.currentMaxStatusID = (self.statuses[self.statuses.count-1] as Status).statusID
                    self.refreshControl.endRefreshing()
                    self.statusTableView.reloadData()
                }
                
            })
            
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Styles navigation bar
        navigationController?.navigationBar.barTintColor = UIColor(red: 90/255.0, green: 200/255.0, blue: 250/255.0, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        navigationController?.navigationBar.backgroundColor = UIColor(red: 90/255.0, green: 200/255.0, blue: 250/255.0, alpha: 1.0)
        self.navigationItem.title = "Profile"
        
        if self.userName == nil {
            self.user = User.currentUser
            self.updateProfilePage()
        } else {
            TwitterClient.sharedInstance.getUser(self.userName!, completion: { (user, error) -> () in
                if (user != nil) {
                    self.user = user
                    self.updateProfilePage()
                }
                
            })
        }
    


        

        
        // Do any additional setup after loading the view.
        
        self.navigationItem.leftBarButtonItem?.title = ""
        
        statusTableView.delegate = self
        statusTableView.dataSource = self
        
        // Sets autolayout dynamic height for rows
        self.statusTableView.rowHeight = UITableViewAutomaticDimension
        
        // Add pull to refresh to the tableview
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: "requestStatuses:maxStatusID:", forControlEvents: UIControlEvents.ValueChanged)
        self.statusTableView.addSubview(refreshControl)
        
        self.requestStatuses(self, maxStatusID: nil)
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.statuses.count > 0 {
            return self.statuses.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Updates each cell with status labels
        let cell = tableView.dequeueReusableCellWithIdentifier("StatusCell") as StatusTableViewCell
        let status = self.statuses[indexPath.row] as Status
        cell.updateLabelsWithStatus(status)
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateProfilePage() {
        
        self.nameLabel.text = self.user.name
        self.userNameLabel.text = "@\(self.user!.screenname!)"
        self.followersCountLabel.text = "\(self.user.followersCount)"
        self.followingCountLabel.text = "\(self.user.followingCount)"
        self.tweetCountLabel.text = "\(self.user.tweetCount)"
        
        
        self.profileBackgroundImageView.setImageWithURL(NSURL(string:self.user!.profileBackgroundURL))
        self.profileImageView.setImageWithURL(NSURL(string:self.user!.profileImageURL!))
        self.profileBackgroundImageView.alpha = 0
        self.profileImageView.alpha = 0
        self.profileImageView.layer.cornerRadius = 10
        self.profileBackgroundImageView.layer.cornerRadius = 10
        self.profileImageView.clipsToBounds = true
        
        // Fade in images
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: nil,
            animations: {
                self.profileImageView.alpha = 1.0
                self.profileBackgroundImageView.alpha = 1.0
                
            },
            completion: {
                finished in
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StatusDetailSegue") {
            // Pass status object to statusDetailViewControlle
            var statusDetailController : StatusDetailViewController = segue.destinationViewController as StatusDetailViewController
            var statusIndex = statusTableView!.indexPathForSelectedRow()?.row
            statusDetailController.status = self.statuses[statusIndex!] as Status
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.statusTableView.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
