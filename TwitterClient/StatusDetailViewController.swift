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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.timeStampLabel.text = status.timeStamp as String
        self.statusLabel.text = status.text
        self.userNameLabel.text = status.username
        self.nameLabel.text = status.name
        self.profileImageURL = status.profileImageURL
        
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
