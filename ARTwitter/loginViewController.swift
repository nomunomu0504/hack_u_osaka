//
//  ViewController.swift
//  twitter-sample
//
//  Created by みさきまさし on 2017/08/19.
//  Copyright © 2017年 arsjam. All rights reserved.
//

import UIKit
import TwitterKit
import EAIntroView



class loginViewController: UIViewController , EAIntroDelegate{
    let tweetView = TWTRTweetView()
    
    
    
    
    
    

    override func viewDidAppear(_ animated: Bool) {

        
//        // 次の遷移先のViewControllerインスタンスを生成する
//        let vc = CameraViewContoller()
//
//        // presentViewControllerメソッドで遷移する
//        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
//        self.present(vc, animated: true, completion: nil) //swift4
//

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
                let page1: EAIntroPage = EAIntroPage()
                page1.title = "ARNet"
                page1.desc = "ARNetを使って、いつもの旅をさらに楽しく"
                page1.titlePositionY = 220
                page1.descPositionY = 220
                page1.titleColor = UIColor.black
                page1.descColor = UIColor.black
                page1.bgImage = UIImage(named: "glass")
        
                let page2: EAIntroPage = EAIntroPage()
                page2.title = "AR"
                page2.desc = "カメラをかざすと、目の前に情報が広がる"
                page2.descColor = UIColor.white
                page2.titleColor = UIColor.white
                page2.titlePositionY = 220
                page2.descPositionY = 220
                page2.bgImage = UIImage(named: "city")
        
                let page3: EAIntroPage = EAIntroPage()
                page3.title = "Twitter or Web"
                page3.desc = "タップによって、TwitterかWebの\nさらに詳しい情報を"
                page3.bgImage = UIImage(named: "rain")
                page3.descColor = UIColor.black
                page3.titleColor = UIColor.black
                page3.titlePositionY = 220
                page3.descPositionY = 220
        
        
                let intro: EAIntroView = EAIntroView(frame: self.view.bounds, andPages: [page1, page2, page3 ])
                intro.delegate = self
                intro.show(in: self.view, animateDuration: 0.0)
        
        
        
//                intro.skipButton.addTarget(self, action: #selector(go), forControlEvents: .TouchUpInside)
        
        

        
        // Swift
        let logInButton = TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                print("signed in as \(session!.userName)");
                
//                        // 次の遷移先のViewControllerインスタンスを生成する
//                let vc = CameraViewContoller()
//
//                        // presentViewControllerメソッドで遷移する
//                        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
//                self.present(vc, animated: true, completion: nil) //swift4
                
                let arview = ViewController()
                
                self.present(arview, animated: true, completion: nil)


                
                
            } else {
                print("error: \(error!.localizedDescription)");
            }
        })
        logInButton.center = self.view.center
        self.view.addSubview(logInButton)
        
        
        self.view.addSubview(intro)


        
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
    
    
    
    var twitterAccount = ACAccount()
    
    
    
    func searchUser(USERNAME: String) -> String{
        
        
        let client = TWTRAPIClient()
        let statusesShowEndpoint = "https://api.twitter.com/1.1/users/search.json"
        let params = ["q": USERNAME]
        var clientError : NSError?
        var return_name = String()
        
        
        let request = client.urlRequest(withMethod: "GET", url: statusesShowEndpoint, parameters: params, error: &clientError)
        
        client.sendTwitterRequest(request) { (response, data, connectionError) -> Void in
            if connectionError != nil {
                print("Error: \(connectionError!)")
            }
            
            do {

                
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [[String:Any]]
                
                
                print("json = ")
                print(json)
//                print(json[0]["name"]!)
                
                if let username_geted = json[0]["screen_name"] as? String{
                    print("json =")
                    print(username_geted)
                    return_name = username_geted
                    
                    
                    print("send_name =")
                    print(return_name)
                    
                    // 次の遷移先のViewControllerインスタンスを生成する
                    let vc = TimeLineView()
                    
                    vc.userName = return_name
                    // presentViewControllerメソッドで遷移する
                    // ここで、animatedをtrueにするとアニメーションしながら遷移できる
                    self.present(vc, animated: true, completion: nil)

                    
                }else{
                    print("error")
                    
                    return_name = "error"
                    
                }
                
//                for obj in json {
//                    //screen_name
//                    if let user = obj["name"] as? [String:Any] {
//                        let screen_name = user["screen_name"] ?? "(empty)"
//                        print("screen_name =", screen_name)
//                    } else {
//                        print("does not exist 'user'")
//                    }
//                    //text
//                    let text = obj["text"] ?? "(empty)"
//                    print("text =", text)
//                }
                
//                print(json["name"] as! [[String:Any]] )
                

            } catch let jsonError as NSError {
                print("json error: \(jsonError.localizedDescription)")
                
                return_name = "error"
                
            }
            
            
        }
        
        
        
        return return_name
        
        
        
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

