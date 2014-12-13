//
//  Status.swift
//  TwitterClient
//
//  Created by Franklin Ho on 9/24/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit

class Status: NSObject {
    var text: NSString
    var profileImageURL: NSString
    var username: NSString
    var name: NSString
    var favorited: Bool
    var favoriteCount: Int
    var retweeted: Bool
    var retweetCount: Int
    var timeSinceTweet: String
    var timeStamp: String
    var statusID: String
    var screenName: String
    
    
    init(dictionary: NSDictionary) {
        self.text = dictionary["text"] as NSString
        
        self.statusID = dictionary["id_str"] as String
        
        var user = dictionary["user"] as NSDictionary
        self.name = user["name"] as NSString
        self.screenName = user["screen_name"] as NSString
        self.username = "@\(screenName)" as NSString
        self.profileImageURL = user["profile_image_url"] as NSString
        
        // Calculate time since tweet creation
        var createdTimeStampString = dictionary["created_at"] as NSString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        var createdTimeStamp : NSDate = dateFormatter.dateFromString(createdTimeStampString)!
        var secondsBetween : NSTimeInterval = NSDate().timeIntervalSinceDate(createdTimeStamp)
        var numberOfMinutesDouble = secondsBetween/60 as Double
        var numberOfMinutes : Int = Int(numberOfMinutesDouble)
        
//        println("\(numberOfMinutes)")
        
        if numberOfMinutes < 60 {
            self.timeSinceTweet = "\(numberOfMinutes)m"
        } else if numberOfMinutes < 1440 && numberOfMinutes >= 60 {
            var hours = Int(numberOfMinutes/60)
            self.timeSinceTweet = "\(hours)h"
        } else {
            let oldDateFormatter = NSDateFormatter()
            oldDateFormatter.dateFormat = "MM/dd/yy"
            self.timeSinceTweet = oldDateFormatter.stringFromDate(createdTimeStamp)
            
        }
        
        let timeStampDateFormatter = NSDateFormatter()
        timeStampDateFormatter.dateFormat = "MM/dd/yy, HH:mm aa"
        self.timeStamp = timeStampDateFormatter.stringFromDate(createdTimeStamp)
        
        var favoritedValue = dictionary["favorited"] as Int
        self.favorited = favoritedValue == 0 ? false:true
        
        self.favoriteCount = dictionary["favorite_count"] as Int
        
        var retweetedValue = dictionary["retweeted"] as Int
        self.retweeted = retweetedValue == 0 ? false:true
        
        self.retweetCount = dictionary["retweet_count"] as Int
        
    }
    
    // Creates status array from dictionary
    class func statusesWithArray(array: [NSDictionary]) -> [Status] {
        var statuses = [Status]()
        
        for dictionary in array{
            statuses.append(Status(dictionary: dictionary))
        }
        return statuses
    }
    
    // Favorites this tweet
    func favorite(){
        TwitterClient.sharedInstance.favoriteStatus(self.statusID)
    }
    
    // Unfavorites this tweet
    func unfavorite(){
        TwitterClient.sharedInstance.unfavoriteStatus(self.statusID)
    }
    
    // Retweets this tweet
    func retweet() {
        TwitterClient.sharedInstance.retweetStatus(self.statusID)
    }
}
