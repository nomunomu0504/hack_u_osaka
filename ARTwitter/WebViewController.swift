//
//  WebViewController.swift
//  
//
//  Created by みさきまさし on 2017/08/23.
//
//

import Foundation


import UIKit

class WebViewController: UIViewController,UIWebViewDelegate {
    
    public var searchWord : String!
    let webView : UIWebView = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        // Delegate設定
        webView.delegate = self
        
        // Webページの大きさを画面に合わせる
        let rect:CGRect = self.view.frame
        webView.frame = rect
        webView.scalesPageToFit = true
        
        // インスタンスをビューに追加する
        self.view.addSubview(webView)
        
        // URLを指定
        
        let targetURL = "https://www.google.co.jp/search?hl=ja&source=hp&q=\(searchWord!)"
        let encodedURL = targetURL.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        
        guard let url = NSURL(string: encodedURL!) else {
            print("無効なURL")
            return
        }
        
        print(url)
        
        let request = NSURLRequest(url: url as URL)
        webView.loadRequest(request as URLRequest)

        
        
        
        //        // UIボタンを作成.
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                myButton.backgroundColor = UIColor.orange
        myButton.layer.masksToBounds = true
        myButton.setTitle("X", for: .normal)
        //        myButton.setTitleColor(for: UIColor.black)
        myButton.setTitleColor(UIColor.black, for: .normal) // タイトルの色
        myButton.layer.cornerRadius = 15.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2 + 140, y:self.view.bounds.height/2 - 230)
        myButton.addTarget(self, action: #selector(returnView), for: .touchUpInside)
        
        // UIボタンをViewに追加.
        self.webView.addSubview(myButton)
        
    }



    //ページが読み終わったときに呼ばれる関数
    func webViewDidFinishLoad(webView: UIWebView) {
        print("ページ読み込み完了しました！")
    }
    //ページを読み始めた時に呼ばれる関数
    func webViewDidStartLoad(webView: UIWebView) {
        print("ページ読み込み開始しました！")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func returnView(){
        
        // 戻る場合には、dismissViewControllerAnimatedメソッドを使います。
        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
        self.dismiss(animated: true, completion: nil)
    }



}
