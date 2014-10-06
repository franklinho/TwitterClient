//
//  User.swift
//  TwitterClient
//
//  Created by Franklin Ho on 9/27/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageURL: String?
    var tagline: String?
    var dictionary: NSDictionary
    var tweetCount: Int
    var followingCount: Int
    var followersCount: Int
    var profileBackgroundURL: String
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        println("Dictionary: \(dictionary)")
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        followersCount = dictionary["followers_count"] as Int
        followingCount = dictionary["friends_count"] as Int
        tweetCount = dictionary["statuses_count"] as Int
        profileBackgroundURL = dictionary["profile_background_image_url"] as String
        println("Profile background Image: \(profileBackgroundURL)")
    }
    
    // Logs user out.
    func logout(){
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object:nil)
        
    }

    // Creates singleton user object.
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
                    var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                    _currentUser = User(dictionary:dictionary)
            }
        
        }
            return _currentUser
        }
        set(user){
            _currentUser = user
            
            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)

            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
    }
}
