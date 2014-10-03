//
//  ProfileViewController.swift
//  TwitterClient
//
//  Created by Franklin Ho on 9/30/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var user: User!
    var statuses: NSMutableArray = []
    
    
    var userName:String?
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tweetCountLabel: UILabel!
    @IBOutlet weak var profileBackgroundImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.userName == nil {
            self.user = User.currentUser
        } else {
            TwitterClient.sharedInstance.getUser(self.userName!, completion: { (user, error) -> () in
                dispatch_async(dispatch_get_main_queue(),{
                    if (user != nil) {
                        self.user = user
                        
                    }
                })
                
            })
        }
        
        self.nameLabel.text = self.user.name
        self.userNameLabel.text = self.user.screenname
        self.followersCountLabel.text = "\(self.user.followersCount)"
        self.followingCountLabel.text = "\(self.user.followingCount)"
        self.tweetCountLabel.text = "\(self.user.tweetCount)"
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.leftBarButtonItem?.title = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
