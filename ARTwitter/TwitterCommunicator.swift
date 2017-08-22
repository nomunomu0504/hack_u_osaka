//
//  TwitterCommunicator.swift
//  ARTwitter
//
//  Created by みさきまさし on 2017/08/22.
//  Copyright © 2017年 arsjam. All rights reserved.
//

import Social
import Accounts

struct TwitterCommunicator {
    func getTimeline(handler: @escaping (Data?, Error?) -> ()) {
        let request = SLRequest(
            forServiceType: SLServiceTypeTwitter,
            requestMethod: .GET,
            url: URL(string: "https://api.twitter.com/1.1/statuses/home_timeline.json"),
            parameters: nil
        )
        
//        request?.account = Account.twitterAccount
        
        request?.perform { data, response, error in
            if let error = error {
                handler(nil, error)
                return
            }
            
            handler(data, error)
        }
    }
}
