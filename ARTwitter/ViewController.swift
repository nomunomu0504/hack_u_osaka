//
//  ViewController.swift
//  twitter-sample
//
//  Created by みさきまさし on 2017/08/19.
//  Copyright © 2017年 arsjam. All rights reserved.
//

import UIKit
import TwitterKit

class ViewController: UIViewController {
    let tweetView = TWTRTweetView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Swift
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
                
                //                self.showSingleTweet()
                //                self.actionForRestAPI()
                //                self.searchUser()
                //                self.displayUser()
                
                //                self.presentViewTimeLine(userId: "723513731930443776")
                
                self.segueToSecondViewController(userId: "723513731930443776")
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Swift
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return Twitter.sharedInstance().application(app, open: url, options: options)
    }
    
    
    func showSingleTweet(){
        // Swift
        let client = TWTRAPIClient()
        client.loadTweet(withID: "20") { (tweet, error) in
            if let t = tweet {
                self.tweetView.configure(with: t)
            } else {
                print("Failed to load Tweet: \(error!.localizedDescription)")
            }
        }
        
        
        self.tweetView.showActionButtons = true
        self.view.addSubview(self.tweetView)
        
    }
    
    func actionForRestAPI(){
        
        // Swift
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/show.json"
        let params = ["id": "20"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError!)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("json: \(json)")
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
    }
    
    func searchUser(){
        
        
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/search.json"
        let params = ["q": "misaki masashi"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError!)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("json: \(json)")
                
//                let obå
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
        
        
    }
    
    
    func displayUser(){
        
        
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/statuses/user_timeline.json"
        let params = ["user_id": "723513731930443776","count":"10"]
        var clientError : NSError?
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError!)")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                print("json: \(json)")
                
            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
            }
        }
    }
    
    
    
    func presentViewTimeLine(userId: String){
        
        // 遷移するViewを定義する.
        var timeLine: UIViewController = TimeLineView()
        
        //        timeLine.showTimeLine(userId:"\(userId)")
        
        
        
        
        // アニメーションを設定する.
        timeLine.modalTransitionStyle = UIModalTransitionStyle.partialCurl
        
        // Viewの移動する.
        self.present(timeLine, animated: true, completion: nil)
    }
    
    
    
    let parameters = ["hello": "こんにちは", "goodbye": "さようなら"]
    
    // Anything...
    
    func segueToSecondViewController(userId: String) {
        self.performSegue(withIdentifier: "toSecondViewController", sender: ["0":"\(userId)"])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSecondViewController" {
            let secondViewController = segue.destination as! TimeLineView
            secondViewController.parameters = sender as! [String : String]
        }
    }
    
    
}

