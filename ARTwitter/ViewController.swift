/*
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


import UIKit
import MapKit
import CoreLocation

import GooglePlaces
import TwitterKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    var mapView: MKMapView!
    var myLocationManager: CLLocationManager!
    
    var arViewController: ARViewController!
    var startedLoadingPOIs = false
    fileprivate var places = [Place]()
    
    var alertFlag = true

    
//    var google_load_flag = false
//
//    var longitude:Double = 0
//    var latitude :Double = 0
//
//    var nowAngle:Double = 0
//
//    var DataArray = Array<Array<Any>>()
//
//    var data_GMSPlaceLikelihood = Array<GMSPlaceLikelihood>()
//
//    var placesClient: GMSPlacesClient!
//    var alertFlag = true
//
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // LocationManagerの生成.
        myLocationManager = CLLocationManager()
        
        // Delegateの設定.
        myLocationManager.delegate = self
        
        // 距離のフィルタ.
        myLocationManager.distanceFilter = 100.0
        
        // 精度.
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // セキュリティ認証のステータスを取得.
        let status = CLLocationManager.authorizationStatus()
        
        // まだ認証が得られていない場合は、認証ダイアログを表示.
        if(status != CLAuthorizationStatus.authorizedWhenInUse) {
            
            print("not determined")
            // まだ承認が得られていない場合は、認証ダイアログを表示.
            myLocationManager.requestWhenInUseAuthorization()
        }
        
        // 位置情報の更新を開始.
        myLocationManager.startUpdatingLocation()
        
        // MapViewの生成.
        mapView = MKMapView()
        
        // MapViewのサイズを画面全体に.
        mapView.frame = self.view.bounds
        
        // Delegateを設定.
        mapView.delegate = self
        
        
        mapView.userTrackingMode = MKUserTrackingMode.followWithHeading
        
        // MapViewをViewに追加.
        self.view.addSubview(mapView)
        
        // 中心点の緯度経度.
        let myLat: CLLocationDegrees = 37.506804
        let myLon: CLLocationDegrees = 139.930531
        let myCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(myLat, myLon) as CLLocationCoordinate2D
        
        // 縮尺.
        let myLatDist : CLLocationDistance = 100
        let myLonDist : CLLocationDistance = 100
        
        // Regionを作成.
        let myRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(myCoordinate, myLatDist, myLonDist);
        
        // MapViewに反映.
        mapView.setRegion(myRegion, animated: true)
        
        
        //        // UIボタンを作成.
        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 50))
//        myButton.backgroundColor = UIColor.orange
        myButton.layer.masksToBounds = true
        myButton.setTitle("camera", for: .normal)
//        myButton.setTitleColor(for: UIColor.black)
        myButton.setTitleColor(UIColor.black, for: .normal) // タイトルの色
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2 + 70, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: #selector(onClickMyButton), for: .touchUpInside)
        
                // UIボタンをViewに追加.
        self.mapView.addSubview(myButton);

        
        
    }
    
    
    // ボタンイベント.
    func onClickMyButton(sender: UIButton){
        
        arViewController = ARViewController()
        arViewController.dataSource = self
        arViewController.maxDistance = 0
        arViewController.maxVisibleAnnotations = 30
        arViewController.maxVerticalLevel = 5
        arViewController.headingSmoothingFactor = 0.05
        
        arViewController.trackingManager.userDistanceFilter = 25
        arViewController.trackingManager.reloadDistanceFilter = 75
        arViewController.setAnnotations(places)
        arViewController.uiOptions.debugEnabled = false
        arViewController.uiOptions.closeButtonEnabled = true
        
        self.present(arViewController, animated: true, completion: nil)
        
        
    }
    
    
    // Regionが変更した時に呼び出されるメソッド.
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("regionDidChangeAnimated")
    }
    
    // 認証が変更された時に呼び出されるメソッド.
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status{
        case .authorizedWhenInUse:
            print("AuthorizedWhenInUse")
        case .authorized:
            print("Authorized")
        case .denied:
            print("Denied")
        case .restricted:
            print("Restricted")
        case .notDetermined:
            print("NotDetermined")
        case .authorizedAlways:
            print("error map")
        }
    }
    
    
    
    func showInfoView(forPlace place: Place) {
        
//        let alert = UIAlertController(title: place.placeName , message: place.infoText, preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//
//        arViewController.present(alert, animated: true, completion: nil)
        
        showalert(placename: place.placeName)
        
        print("tapped!")
        
        
    }
    
    
    
    
    func showalert(placename:String){
        
        
        if alertFlag == true{
            
            alertFlag = false
            
            
            let alert: UIAlertController = UIAlertController(title: "店を見つけました", message: "\(placename)の何を見たいですか？", preferredStyle:  UIAlertControllerStyle.actionSheet)
            
            
            let defaultAction: UIAlertAction = UIAlertAction(title: "web", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                
                // 次の遷移先のViewControllerインスタンスを生成する
                let vc = WebViewController()
                
                vc.searchWord = "\(placename as! String)"
                // presentViewControllerメソッドで遷移する
                // ここで、animatedをtrueにするとアニメーションしながら遷移できる
                self.arViewController.present(vc, animated: true, completion: nil)
                
//                self.alertFlag = true
                
                print("OK")
            })
            
            
            let defaultAction2: UIAlertAction = UIAlertAction(title: "Twitter", style: UIAlertActionStyle.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("OK")
                
                
                
                self.searchUser(USERNAME: placename) //twitter 遷移
                //                self.searchUser(USERNAME: "hanadojo")
                
                self.alertFlag = true
            })
            
            
            // キャンセルボタン
            let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
                print("Cancel")
                self.alertFlag = true
            })
            
            // ③ UIAlertControllerにActionを追加
            alert.addAction(cancelAction)
            alert.addAction(defaultAction2)
            alert.addAction(defaultAction)
            
            // ④ Alertを表示
            arViewController.present(alert, animated: true, completion: nil)
            
        }
        
    }

    
    
    
    
    
    
    
    
    
    
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
                
                //twitter pageを見つけられなかった場合
                let alert: UIAlertController = UIAlertController(title: "Twitterアカウントを見つけられませんでした", message: "", preferredStyle:  UIAlertControllerStyle.actionSheet)
                
                
                
                let defaultAction: UIAlertAction = UIAlertAction(title: "web", style: UIAlertActionStyle.default, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    
                    // 次の遷移先のViewControllerインスタンスを生成する
                    let vc = WebViewController()
                    
                    vc.searchWord = "\(USERNAME)"
                    // presentViewControllerメソッドで遷移する
                    // ここで、animatedをtrueにするとアニメーションしながら遷移できる
                    self.arViewController.present(vc, animated: true, completion: nil)
                    
                    self.alertFlag = true
                    
                    print("OK")
                })
                
                
                
                
                // キャンセルボタン
                let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler:{
                    // ボタンが押された時の処理を書く（クロージャ実装）
                    (action: UIAlertAction!) -> Void in
                    print("Cancel")
                    self.alertFlag = true
                })
                
                // ③ UIAlertControllerにActionを追加
                alert.addAction(cancelAction)
                
                alert.addAction(defaultAction)
                
                // ④ Alertを表示
                self.arViewController.present(alert, animated: true, completion: nil)
                
                
                
                
            }else{
                
                do {
                    
                    //                print("data =")
                    //                print(data!)
                    
                    // NSData to String
                    //                let out: String = NSString(data:data!, encoding:String.Encoding.utf8.rawValue) as! String
                    //                print(out) // ==> Hello
                    
                    
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
                        self.arViewController.present(vc, animated: true, completion: nil)
                        
                        
                    }else{
                        print("error")
                        
                        return_name = "error"
                        
                    }
                    
                    
                } catch let jsonError as NSError {
                    print("json error: \(jsonError.localizedDescription)")
                    
                    return_name = "error"
                    
                }
                
                
            }
        }
        
        
        
        return return_name
        
        
        
    }
    
    
    

}





extension ViewController  {
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        return true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.count > 0 {
            let location = locations.last!
            if location.horizontalAccuracy < 100 {
                manager.stopUpdatingLocation()
                let span = MKCoordinateSpan(latitudeDelta: 0.014, longitudeDelta: 0.014)
                let region = MKCoordinateRegion(center: location.coordinate, span: span)
                mapView.region = region
                
                if !startedLoadingPOIs {
                    startedLoadingPOIs = true
                    let loader = PlacesLoader()
                    loader.loadPOIS(location: location, radius: 200) { placesDict, error in
                        if let dict = placesDict {
                            guard let placesArray = dict.object(forKey: "results") as? [NSDictionary]  else { return }
                            
                            for placeDict in placesArray {
                                let latitude = placeDict.value(forKeyPath: "geometry.location.lat") as! CLLocationDegrees
                                let longitude = placeDict.value(forKeyPath: "geometry.location.lng") as! CLLocationDegrees
                                let reference = placeDict.object(forKey: "reference") as! String
                                let name = placeDict.object(forKey: "name") as! String
                                let address = placeDict.object(forKey: "vicinity") as! String
                                
                                let location = CLLocation(latitude: latitude, longitude: longitude)
                                let place = Place(location: location, reference: reference, name: name, address: address)
                                
                                self.places.append(place)
                                let annotation = PlaceAnnotation(location: place.location!.coordinate, title: place.placeName)
                                DispatchQueue.main.async {
                                    self.mapView.addAnnotation(annotation)
                                }
                            }
                        }
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                }
            }
        }
    }
}

extension ViewController: ARDataSource {
    func ar(_ arViewController: ARViewController, viewForAnnotation: ARAnnotation) -> ARAnnotationView {
        let annotationView = AnnotationView()
        annotationView.annotation = viewForAnnotation
        annotationView.delegate = self
        annotationView.frame = CGRect(x: 0, y: 0, width: 150, height: 50)
        
        return annotationView
    }
}

extension ViewController: AnnotationViewDelegate {
    func didTouch(annotationView: AnnotationView) {
        if let annotation = annotationView.annotation as? Place {
            let placesLoader = PlacesLoader()
            placesLoader.loadDetailInformation(forPlace: annotation) { resultDict, error in
                
                if let infoDict = resultDict?.object(forKey: "result") as? NSDictionary {
                    annotation.phoneNumber = infoDict.object(forKey: "formatted_phone_number") as? String
                    annotation.website = infoDict.object(forKey: "website") as? String
                    
                    self.showInfoView(forPlace: annotation)
                }
            }
            
        }
    }
}


