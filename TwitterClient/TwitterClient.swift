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
    
    class var sharedInstance : TwitterClient {
        struct Static {
            static let instance =  TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (statuses:[Status]?, error: NSError?) -> ()) {
        
        
        GET("1.1/statuses/home_timeline.json", parameters: params, success: {(operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            println("home timeline: \(response)")
            var statuses = Status.statusesWithArray(response as [NSDictionary])
            completion(statuses: statuses, error: nil)
        
        }, failure: {(operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            println("Error getting home timeline")
            completion(statuses: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request tokena and redirect to authorization page
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
            println("Got the request token")
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(authURL)
            }) {(error:NSError!) -> Void in
                println("Failed to get request token")
                self.loginCompletion?(user: nil, error: error)
        }
        
    }
    
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
    
    
//    func requestHomeTimeLine() -> [Status] {
//        var statusArray: [Status] = []
//        
//        accountStore.requestAccessToAccountsWithType(accountType, options: nil) { (success, error) in
//            if success {
//                let accounts = accountStore.accountsWithAccountType(accountType)
//                let url = NSURL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json")
//                
//                let authRequest = SLRequest(forServiceType: SLServiceTypeTwitter, requestMethod: .GET, URL: url, parameters: nil)
//                
//                
//                if accounts.count > 0 {
//                    authRequest.account = accounts[0] as ACAccount
//                    
//                    let request = authRequest.preparedURLRequest()
//                    
//                    let task = self.urlSession.dataTaskWithRequest(request,completionHandler: { (data, response, error) in
//                        if error != nil {
//                            NSLog("Error getting timeline")
//                        } else {
//                            let array = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSArray
//                            
//                            println("Object: \(array)")
//                            for object in array {
//                                let dictionary = object as NSDictionary
//
//                                
//                                statusArray.append(Status(dictionary: dictionary))
//                            }
//                        }
//                    })
//                    task.resume()
//                    
//                }
//                
//                
//                
//                NSLog("Accounts: \(accounts)")
//            } else {
//                NSLog("Error: \(error)")
//            }
//        }
//        
//    }
    
}





