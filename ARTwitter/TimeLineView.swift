//
//  TimeLineView.swift
//  twitter-sample
//
//  Created by みさきまさし on 2017/08/20.
//  Copyright © 2017年 arsjam. All rights reserved.
//

import UIKit
import TwitterKit
import Foundation

class TimeLineView: TWTRTimelineViewController {
    public var userId: String?
    var parameters: [String : String] = [:]
    public var userName: String!
    
    let client = TWTRAPIClient()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        Twitter.sharedInstance().logIn { session, error in
            if (session != nil) {
                // ユーザ名からタイムラインを取得
                self.dataSource = TWTRUserTimelineDataSource(screenName: self.userName, apiClient: self.client)
            } else {
                print("error: \(error!.localizedDescription)")
            }
        }
        
//        showTimeLine(userId: self.userId!)
    }
    
    public func showTimeLine(userId: String){
        let client = TWTRAPIClient(userID: userId)
        self.dataSource = TWTRUserTimelineDataSource(screenName: "time", apiClient: client)

    }
    
}



//class TimelineViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    var tableView: UITableView!
//    var tweets: [TWTRTweet] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//    var prototypeCell: TWTRTweetTableViewCell?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView = UITableView(frame: self.view.bounds)
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        prototypeCell = TWTRTweetTableViewCell(style: .default, reuseIdentifier: "cell")
//        
//        tableView.register(TWTRTweetTableViewCell.self, forCellReuseIdentifier: "cell")
//        self.view.addSubview(tableView)
//        
//        loadTweets()
//    }
//    
//    func loadTweets() {
//        TwitterCommunicator.getTimeline({
//            twttrs in
//            for tweet in twttrs {
//                self.tweets.append(tweet)
//            }
//        }, error: {
//            error in
//            print("" (error.localizedDescription))
//        })
//    }
//    
//    // MARK: UITableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // Return the number of Tweets.
//        return tweets.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TWTRTweetTableViewCell
//        
//        let tweet = tweets[indexPath.row]
//        cell.configure(with: tweet)
//        
//        return cell
//    }
//    
//    // MARK: UITableViewDelegate
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let tweet = tweets[indexPath.row]
//        
//        prototypeCell?.configure(with: tweet)
//        
//        if let height = prototypeCell?.calculatedHeightForWidth(self.view.bounds.width) {
//            return height
//        } else {
//            return tableView.estimatedRowHeight
//        }
//    }
//}
