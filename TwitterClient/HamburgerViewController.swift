//
//  HamburgerViewController.swift
//  TwitterClient
//
//  Created by Franklin Ho on 10/2/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    

    
    var sb : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var viewControllers : [UIViewController]!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userScreenNameLable: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var centerConstraint: NSLayoutConstraint!
    
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil){
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    

   

    

    @IBAction func didSwipe(sender: AnyObject) {
        if sender.state == .Ended {
            UIView.animateWithDuration(0.35, animations: {
                self.centerConstraint.constant = -160
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
    override func viewDidLoad() {
        var statusVC : UIViewController = sb.instantiateViewControllerWithIdentifier("StatusesViewController") as UIViewController
        var profileVC : ProfileViewController = sb.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
        viewControllers = [statusVC,profileVC]
        
        
        self.centerConstraint.constant = 0
        self.activeViewController = viewControllers.first
        
        var user : User = User.currentUser!
        
        self.userNameLabel.text = user.name
        self.userScreenNameLable.text = "@\(user.screenname!)"
        
        self.userImageView.setImageWithURL(NSURL(string:user.profileImageURL!))
        self.userImageView.alpha = 0
        self.userImageView.layer.cornerRadius = 10
        self.userImageView.clipsToBounds = true
        
        // Fade in images
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: nil,
            animations: {
                self.userImageView.alpha = 1.0
                
            },
            completion: {
                finished in
        })
    }
    @IBAction func didTapButton(sender: UIButton) {
        if sender == redButton {
            self.activeViewController = viewControllers.first
            println("Red Button")
        } else if sender == blueButton{
            println("\(viewControllers)")
            self.activeViewController = viewControllers.last
            println("Blue button")
        } else {
            println("Unknown button")
        }
        
        UIView.animateWithDuration(0.35, animations: {
                self.centerConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
    }
    
    
    @IBAction func didTapContentView(sender: AnyObject) {
        UIView.animateWithDuration(0.35, animations: {
            self.centerConstraint.constant = 0
            self.view.layoutIfNeeded()
        })
    }
    
}

class RedViewController: UIViewController {
    override func loadView() {
        self.view = UIView(frame: CGRectZero)
        self.view.backgroundColor = UIColor.redColor()
    }
}

class BlueViewController: UIViewController {
    override func loadView() {
        self.view = UIView(frame: CGRectZero)
        self.view.backgroundColor = UIColor.blueColor()
    }
}
