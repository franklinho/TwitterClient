//
//  ComposerViewController.swift
//  TwitterClient
//
//  Created by Franklin Ho on 9/24/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit

class ComposerViewController: UIViewController,UITextViewDelegate {


    @IBOutlet weak var textViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var composerTextView: UITextView!
    

    @IBOutlet weak var characterCountLabel: UILabel!
    var characterCount : Int!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.


        
        // Notification for when keyboard size is changed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyBoardWillChange:", name: UIKeyboardWillChangeFrameNotification, object: nil)
        
        // Set compose view delegate to self
        self.composerTextView.delegate = self
        
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
    
    func checkCharacters(){
        // Looks at textview character count
        self.characterCount = countElements(composerTextView.text)
        // Displays characters left from 140
        var remainingCharacters = 140-self.characterCount
        self.characterCountLabel.text = "\(remainingCharacters)"
        if remainingCharacters < 0 {
            self.characterCountLabel.textColor = UIColor.redColor()
        } else {
            // If negative, make label red
            self.characterCountLabel.textColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
        }
    }
    
    // Dismiss composeview
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.view.endEditing(true)
    }
}
