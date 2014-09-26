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
//    var favorited: Bool
//    var favoriteCount: Int
//    var retweeted: Bool
//    var retweetCount: Int
    var timeSinceTweet: String
    var timeStamp: String
    
    
    init(dictionary: NSDictionary) {
        self.text = dictionary["text"] as NSString

        var user = dictionary["user"] as NSDictionary
        self.name = user["name"] as NSString
        var screenName = user["screen_name"] as NSString
        self.username = "@\(screenName)" as NSString
        self.profileImageURL = user["profile_image_url"] as NSString
        
        // Calculate time since tweet creation
        var createdTimeStampString = dictionary["created_at"] as NSString
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "eee MMM dd HH:mm:ss ZZZZ yyyy"
        var createdTimeStamp : NSDate = dateFormatter.dateFromString(createdTimeStampString)!
        var secondsBetween : NSTimeInterval = NSDate.date().timeIntervalSinceDate(createdTimeStamp)
        var numberOfMinutesDouble = secondsBetween/60 as Double
        var numberOfMinutes : Int = Int(numberOfMinutesDouble)
        
        println("\(numberOfMinutes)")
        
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
        
    }
}
