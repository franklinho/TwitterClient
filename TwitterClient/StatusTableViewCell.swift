//
//  StatusTableViewCell.swift
//  TwitterClient
//
//  Created by Franklin Ho on 9/24/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit

class StatusTableViewCell: UITableViewCell {
    
    

    @IBOutlet weak var userNameLabel: UILabel!

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Quickly updates statusTableViewCell with data from status
    func updateLabelsWithStatus(status:Status) {
        self.statusLabel.text = status.text
        self.timeLabel.text = status.timeSinceTweet
        self.nameLabel.text = status.name
        self.userNameLabel.text = status.username
        self.profileImage.setImageWithURL(NSURL(string:status.profileImageURL))
        self.profileImage.alpha = 0
        self.profileImage.layer.cornerRadius = 10
        self.profileImage.clipsToBounds = true
        
        // Fade in images
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: nil,
            animations: {
                self.profileImage.alpha = 1.0
                
            },
            completion: {
                finished in
        })
    }
    

}
