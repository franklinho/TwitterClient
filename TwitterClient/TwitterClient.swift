//
//  TwitterClient.swift
//  TwitterClient
//
//  Created by Franklin Ho on 9/26/14.
//  Copyright (c) 2014 Franklin Ho. All rights reserved.
//

import UIKit
import Accounts
import Social

let twitterConsumerKey = "neaLRJESozIcazskqLocrIU7i"
let twitterConsumerSecret = "40thao2Bw7jiQXZi7wb2cDnn69ACWWlDpyN84ULang4R2YtN9a"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")
let accountStore = ACAccountStore()
let accountType = accountStore.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter)


class TwitterClient: BDBOAuth1RequestOperationManager {
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    // Create singleton Twitter Client
    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance =  TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    // Pulls home timeline statuses
    func homeTimelineWithParams(params: NSDictionary?, completion: (statuses:[Status]?, error: NSError?) -> ()) {
        
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            println("home timeline: \(response)")
            var statuses = Status.statusesWithArray(response as [NSDictionary])
            completion(statuses: statuses, error: nil)
        
        }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Error getting home timeline: \(error)")
            completion(statuses: nil, error: error)
        })
    }
    
    // Pulls user details
    func getUser(userName: String, completion: (user:User?, error: NSError?) -> ()) {
        
        
        GET("1.1/users/show.json", parameters: ["screen_name":userName], success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var user = User(dictionary: response as NSDictionary)
            completion(user: user, error: nil)
            
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting user")
                completion(user: nil, error: error)
        })
    }
    
    // Pulls user timeline statuses
    func userTimeLineWithParams(params: NSDictionary?, completion: (statuses:[Status]?, error: NSError?) -> ()) {
        
        
        GET("1.1/statuses/user_timeline.json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //            println("home timeline: \(response)")
            var statuses = Status.statusesWithArray(response as [NSDictionary])
            completion(statuses: statuses, error: nil)
            
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting user timeline")
                completion(statuses: nil, error: error)
        })
    }
    
    
    // Posts Tweet, takes replyID argument
    func updateStatus(statusText: String, replyID: String?){
        var params = ["status":statusText]
        if replyID != nil {
            params["in_reply_to_status_id"] = replyID!
        }
        POST("1.1/statuses/update.json", parameters: ["status":statusText], success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Tweet Posted: \(statusText)")
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to post tweet")
        })
    }
    
    //Favorites Status
    func favoriteStatus(statusID: String){
        POST("1.1/favorites/create.json", parameters: ["id":statusID], success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("Favorited Tweet: \(statusID)")
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to favorite tweet")
            })
    }
    
    //Unfavorites Status
    func unfavoriteStatus(statusID: String){
        POST("1.1/favorites/destroy.json", parameters: ["id":statusID], success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Unfavorited Tweet: \(statusID)")
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to unfavorite tweet")
        })
    }
    
    // Retweeets a status
    func retweetStatus(statusID: String) {
        POST("1.1/statuses/retweet/\(statusID).json", parameters: ["id":statusID], success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Retweeted Tweet: \(statusID)")
            }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to retweet tweet: \(error)")
        })
    }
    
    // Logs user in. Gets Oauth token.
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request tokena and redirect to authorization page
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            }) {(error:NSError!) -> Void in
                println("Failed to get request token: \(error)")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
    // Checks if app is opened with a url and gets request token.
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken(queryString: url.query), success: { (accessToken: BDBOAuthToken!) -> Void in
            println("Got the access token!")
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println("user: \(response)")
                var user = User(dictionary: response as NSDictionary)
                println("user: \(user.name)")
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                    println("error getting current user")
                    self.loginCompletion?(user: nil, error: error)
            })
            
            
            
            
            }) { (error: NSError!) -> Void in
                println("Failed to receive access token")
                self.loginCompletion?(user: nil, error: error)
        }
    }
    
    
    

}





