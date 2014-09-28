//
//  ComposerViewController.swift
//  TwitterClient
//
//  Created by Franklin Ho on 9/24/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit

// Protocol for passing Tweet data back to main ViewController
protocol ComposerViewControllerDelegate{
    func didFinishComposingStatus(statusText:String)
}

class ComposerViewController: UIViewController,UITextViewDelegate {
    
    var delegate: ComposerViewControllerDelegate?
    
    @IBOutlet weak var tweetButton: UIButton!

    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var composerTextView: UITextView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userScreenName: UILabel!

    @IBOutlet weak var characterCountLabel: UILabel!
    
    var replyId: String?
    var replyUsername: String?
    
    var characterCount : Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.userName.text = User.currentUser?.name
        self.userScreenName.text = User.currentUser?.screenname
        var userImageURL = User.currentUser?.profileImageURL
        
        self.userImage.setImageWithURL(NSURL(string: userImageURL!))
        self.userImage.alpha = 0
        self.userImage.layer.cornerRadius = 10
        self.userImage.clipsToBounds = true
        
        // Fade in images
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: nil,
            animations: {
                self.userImage.alpha = 1.0
                
            },
            completion: {
                finished in
        })
        
        if self.replyUsername != nil {
            self.composerTextView.text = self.replyUsername!+" "
        }
        
        self.composerTextView.becomeFirstResponder()
        
        // Notification for when keyboard size is changed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // Set compose view delegate to self
        self.composerTextView.delegate = self
        
        self.tweetButton.userInteractionEnabled = false
        self.tweetButton.titleLabel?.textColor = UIColor.grayColor()
        
        // Check how many characters are in the textfield and update character count label
        self.checkCharacters()
        
        
        
        
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
    
    // When text is changed, update character count label
    func textViewDidChange(textView: UITextView) {
        self.checkCharacters()
    }
    
    func keyBoardWillChange(notification: NSNotification) {
        // Adjusts size of text view to scroll when keyboard is up
        var keyBoardRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        self.view.convertRect(keyBoardRect, fromView: nil)
        
        self.textViewBottomConstraint.constant = keyBoardRect.height
    }
    
    // Checks how many characters are in the tweet.
    func checkCharacters(){
        // Looks at textview character count
        self.characterCount = countElements(composerTextView.text)
        // Displays characters left from 140
        var remainingCharacters = 140-self.characterCount
        self.characterCountLabel.text = "\(remainingCharacters)"
        if remainingCharacters < 0 {
            self.characterCountLabel.textColor = UIColor.redColor()
            self.tweetButton.userInteractionEnabled = false
            self.tweetButton.titleLabel?.textColor = UIColor.grayColor()
        } else {
            // If negative, make label red
            self.characterCountLabel.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
            self.tweetButton.userInteractionEnabled = true
            self.tweetButton.titleLabel?.textColor = UIColor(red: 90/255.0, green: 200/255.0, blue: 250/255.0, alpha: 1.0)
        }
        
        if countElements(composerTextView.text) == 0 {
            self.tweetButton.userInteractionEnabled = false
            self.tweetButton.titleLabel?.textColor = UIColor.grayColor()
        }
    }
    
    // Dismiss composeview
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.view.endEditing(true)
    }
    
    // Sends tweet
    @IBAction func tweetButtonPressed(sender: AnyObject) {
        TwitterClient.sharedInstance.updateStatus(self.composerTextView.text, replyID: self.replyId)
        self.delegate?.didFinishComposingStatus(self.composerTextView.text)
        self.view.endEditing(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}
