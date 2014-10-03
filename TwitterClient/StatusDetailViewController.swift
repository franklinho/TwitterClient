//
//  statusDetailViewController.swift
//  
//
//  Created by Franklin Ho on 9/25/14.
//
//

import UIKit

class StatusDetailViewController: UIViewController {
    var status : Status!
    var profileImageURL : String!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    var currentFavoritesCount : Int!
    var currentRetweetCount: Int!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Assigns status variables to detailViewController Labels
        self.timeStampLabel.text = status.timeStamp as String
        self.statusLabel.text = status.text
        self.userNameLabel.text = status.username
        self.nameLabel.text = status.name
        self.profileImageURL = status.profileImageURL
        self.retweetCountLabel.text = String(status.retweetCount)
        self.favoritesCountLabel.text = String(status.favoriteCount)
        self.favoriteButton.selected = status.favorited ? true:false
        self.retweetButton.selected = status.retweeted ? true: false
        self.currentFavoritesCount = status.favoriteCount
        self.currentRetweetCount = status.retweetCount
        
        
        // Loads and fades image in
        self.profileImageView.setImageWithURL(NSURL(string:self.profileImageURL))
        self.profileImageView.alpha = 0
        self.profileImageView.layer.cornerRadius = 10
        self.profileImageView.clipsToBounds = true
        
        
        
        // Fade in images
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: nil,
            animations: {
                self.profileImageView.alpha = 1.0
                
            },
            completion: {
                finished in
        })
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func favoriteButtonPressed(sender: AnyObject) {
        if self.favoriteButton.selected == false {
            self.status.favorite()
            self.favoriteButton.selected = true
            self.currentFavoritesCount = self.currentFavoritesCount+1
            self.favoritesCountLabel.text = String(self.currentFavoritesCount)

        } else {
            self.status.unfavorite()
            self.favoriteButton.selected = false
            self.currentFavoritesCount = self.currentFavoritesCount-1
            self.favoritesCountLabel.text = String(self.currentFavoritesCount)
        }
        
        
    }
    @IBAction func retweetButtonPressed(sender: AnyObject) {
        if self.retweetButton.selected == false {
            self.status.retweet()
            self.retweetButton.selected = true
            self.currentRetweetCount = self.currentRetweetCount+1
            self.retweetCountLabel.text = String(self.currentRetweetCount)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Passes filter data from StatusDetailViewController to ComposerViewController
        if (segue.identifier == "ReplyComposeSegue") {
            var composeViewController : ComposerViewController = segue.destinationViewController as ComposerViewController
            composeViewController.replyId = self.status.statusID
            composeViewController.replyUsername = self.status.username
            
        } else if (segue.identifier == "profileSegue") {
            var profileController: ProfileViewController = segue.destinationViewController as ProfileViewController
            profileController.userName = self.status.screenName
        }
    }

}
