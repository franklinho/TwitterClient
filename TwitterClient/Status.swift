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
    init(dictionary: NSDictionary) {
        self.text = dictionary["text"] as NSString
    }
}
