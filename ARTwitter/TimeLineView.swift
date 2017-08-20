//
//  TimeLineView.swift
//  twitter-sample
//
//  Created by みさきまさし on 2017/08/20.
//  Copyright © 2017年 arsjam. All rights reserved.
//

import UIKit
import TwitterKit

class TimeLineView: TWTRTimelineViewController {
    public var userId: String?
    var parameters: [String : String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showTimeLine(userId: parameters["0"]!)
    }
    
    public func showTimeLine(userId: String){
        let client = TWTRAPIClient(userID: userId)
        self.dataSource = TWTRUserTimelineDataSource(screenName: "time", apiClient: client)

    }
    
}
