//
//  CameraViewcontroller.swift
//  ARTwitter
//
//  Created by みさきまさし on 2017/08/22.
//  Copyright © 2017年 arsjam. All rights reserved.
//


import UIKit
import AVFoundation

import GooglePlaces
import CoreLocation


class CameraViewContoller: UIViewController,  CLLocationManagerDelegate {
    
    // セッション.
    var mySession : AVCaptureSession!
    // デバイス.
    var myDevice : AVCaptureDevice!
    // 画像のアウトプット.
    var myImageOutput: AVCaptureStillImageOutput!
    
    
    var google_load_flag = false
    
    var longitude:Double = 0
    var latitude :Double = 0
    
    var nowAngle:Double = 0
    
    var DataArray = Array<Array<Any>>()
    
    var data_GMSPlaceLikelihood = Array<GMSPlaceLikelihood>()
    
    var placesClient: GMSPlacesClient!
    var alertFlag = true
    
    var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        // ボタンのサイズを定義.
        let bWidth: CGFloat = 200
        let bHeight: CGFloat = 50
        
        // 配置する座標を定義(画面の中心).
        let posX: CGFloat = self.view.bounds.width/2 - bWidth/2
        let posY: CGFloat = self.view.bounds.height/2 - bHeight/2
        
        // Labelを作成.
        let label: UILabel = UILabel(frame: CGRect(x: posX, y: posY, width: bWidth, height: bHeight))
        
        // UILabelの背景をオレンジ色に.
        label.backgroundColor = UIColor.orange
        
        // UILabelの枠を丸くする.
        label.layer.masksToBounds = true
        
        // 丸くするコーナーの半径.
        label.layer.cornerRadius = 20.0
        
        // 文字の色を白に定義.
        label.textColor = UIColor.white
        
        // UILabelに文字を代入.
        label.text = "Hello Swift!!"
        
        // 文字の影をグレーに定義.
        label.shadowColor = UIColor.gray
        
        // Textを中央寄せにする.
        label.textAlignment = NSTextAlignment.center
        
        // Viewの背景を青にする.
        self.view.backgroundColor = UIColor.cyan
        
        // ViewにLabelを追加.
        self.view.addSubview(label)

        
        
        
        
        // google place api 起動
        placesClient = GMSPlacesClient.shared()
        
        tapStart()
        getCurrentPlace()
        
        
        // セッションの作成.
        mySession = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
       //バックカメラをcameraDevicesに格納
        for device in devices! {
            if (device as! AnyObject).position == AVCaptureDevicePosition.back {
                myDevice = device as! AVCaptureDevice
            }
        }

        // バックカメラからVideoInputを取得.
        let videoInput = try! AVCaptureDeviceInput.init(device: myDevice)
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer = AVCaptureVideoPreviewLayer.init(session: mySession)
        myVideoLayer?.frame = self.view.bounds
        myVideoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer!)
        
        // セッション開始.
        mySession.startRunning()
        
//        // UIボタンを作成.
//        let myButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
//        myButton.backgroundColor = UIColor.red
//        myButton.layer.masksToBounds = true
//        myButton.setTitle("撮影", for: .normal)
//        myButton.layer.cornerRadius = 20.0
//        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
//        myButton.addTarget(self, action: #selector(onClickMyButton), for: .touchUpInside)
//
//        // UIボタンをViewに追加.
//        self.view.addSubview(myButton);
        
    }
    
    // ボタンイベント.
    func onClickMyButton(sender: UIButton){
        
        // ビデオ出力に接続.
        // let myVideoConnection = myImageOutput.connectionWithMediaType(AVMediaTypeVideo)
//        let myVideoConnection = myImageOutput.connection(withMediaType: AVMediaTypeVideo)
        
        // 接続から画像を取得.
//        self.myImageOutput.captureStillImageAsynchronously(from: myVideoConnection, completionHandler: {(imageDataBuffer, error) in
//            if let e = error {
//                print(e.localizedDescription)
//                return
//            }
//            // 取得したImageのDataBufferをJpegに変換.
//            let myImageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: imageDataBuffer!, previewPhotoSampleBuffer: nil)
//            // JpegからUIIMageを作成.
//            let myImage = UIImage(data: myImageData!)
//            // アルバムに追加.
//            UIImageWriteToSavedPhotosAlbum(myImage!, nil, nil, nil)
//        })
    }
    
    
    
    
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    func getCurrentPlace() {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
//            self.nameLabel.text = "No current place"
//            self.addressLabel.text = ""
            
            print("No current place")
            
            //            print("place list")
            //            print("\(String(describing: placeLikelihoodList!.likelihoods[1]))")
            
            print("place list count")
            print("\(String(describing: placeLikelihoodList!.likelihoods.count))")
            
            
            self.data_GMSPlaceLikelihood = placeLikelihoodList!.likelihoods
            
            self.appendDistance(loadData: self.data_GMSPlaceLikelihood)
            
            
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                
                self.google_load_flag = true
                
                
            }
        })
    }
    
    
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let locationData = locations.last
        if let lng = locationData?.coordinate.longitude {
//            lngLabel.text = String(format:"%.6f",lng)
        }
        if let lat = locationData?.coordinate.latitude {
//            latLabel.text = String(format:"%.6f",lat)
        }
        if let alt = locationData?.altitude {
//            altLabel.text = String(format:"%.6f",alt)
        }
        
        
        
        self.latitude = Double(locationData!.coordinate.latitude) //現在の位置
        
        self.longitude = Double(locationData!.coordinate.longitude) //現在の位置
        
        
//        if self.google_load_flag == true {
//
//            print("location latitude: \(Double(locationData!.coordinate.latitude)) location longitude: \(Double(locationData!.coordinate.longitude))")
//            //            print("latitude: \(self.latitude) longitude: \(self.longitude)")
//
//            //35.9304939,136.1857218,15 サンドーム
//
//            //            print(angle(a:Point(x: Double(locationData!.coordinate.latitude), y: Double(locationData!.coordinate.longitude)),
//            //                        b: Point(x: self.latitude, y: self.longitude)))
//
//
//
//
//            self.appendDistance(loadData: self.data_GMSPlaceLikelihood)
//
//
//            //            self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
//            //                .joined(separator: "\n")
//
//
//
//
//
//            let angle_:Double = angle(a: Point(x: self.latitude, y: self.longitude),
//                                      b: Point(x: Double(self.DataArray[0][2] as! Double),
//                                               y: Double(self.DataArray[0][3] as! Double)) //ここを変更
//            )
//
//
////            self.label.text = self.DataArray[0][0] as! String
//
//            print("place name")
//            print(self.DataArray[0])
//
//            print("angle")
//            print(String(angle_))
//
//            if AngularDeviation(angle1: self.nowAngle, angle2: angle_) < 20 {
//
//                print("Detect Place!!")
//
//                showalert()
//
//            }
//
//
//
//        }
    }
    
    
    
    
    func serachPlace(){
        
        if self.google_load_flag == true {
            
  
            
            self.appendDistance(loadData: self.data_GMSPlaceLikelihood)
            
            
            
            
            
            
            let angle_:Double = angle(a: Point(x: self.latitude, y: self.longitude),
                                      b: Point(x: Double(self.DataArray[0][2] as! Double),
                                               y: Double(self.DataArray[0][3] as! Double)) //ここを変更
            )
            

            
            print("place name")
            print(self.DataArray[0])
            
            
            print("now angle")
            print(self.nowAngle)
            
            print("angle")
            print(String(angle_))
            
            if AngularDeviation(angle1: self.nowAngle, angle2: angle_) < 20 {
                
                print("Detect Place!!")
                
                showalert()
                
            }
            
            
            
        }
        
    }
    
    
    
    
    
    
    func showalert(){
        
        
        if alertFlag == true{
            // UIAlertControllerを作成する.
            let myAlert: UIAlertController = UIAlertController(title: "タイトル", message: "メッセージ", preferredStyle: .alert)
            
            alertFlag = false
            // OKのアクションを作成する.
            let myOkAction = UIAlertAction(title: "OK", style: .default) { action in
                print("Action OK!!")
                self.alertFlag = true
                
            }
            
            // OKのActionを追加する.
            myAlert.addAction(myOkAction)
            
            // UIAlertを発動する.
            present(myAlert, animated: true, completion: nil)
        }
        
    }
    
    
    let lm = CLLocationManager()
    
    
    func tapStart() {
        disabledLocationLabel()
        lm.requestWhenInUseAuthorization()
        lm.delegate = self
        startLocationService()
        startHeadingService()
    }
    
    func tapStop() {
        lm.stopUpdatingLocation()
        lm.stopUpdatingHeading()
    }
    
    
    func startHeadingService() {
//        northSwitch.selectedSegmentIndex = 0
        lm.headingOrientation = .portrait
        lm.headingFilter = 1
        lm.startUpdatingHeading()
    }
    
    func startLocationService() {
        lm.desiredAccuracy = kCLLocationAccuracyBest
        lm.distanceFilter = 1
        lm.startUpdatingLocation()
    }
    
    func disabledLocationLabel() {
        let msg = "位置情報の利用が未許可"
        print(msg)
//        lngLabel.text = msg
//        latLabel.text = msg
//        altLabel.text = msg
    }
    
    
    
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse :
            lm.startUpdatingLocation()
        case .notDetermined:
            lm.stopUpdatingLocation()
            disabledLocationLabel()
        default:
            lm.stopUpdatingLocation()
            disabledLocationLabel()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        var arg = newHeading.magneticHeading - newHeading.trueHeading
        if arg < 0 { arg += 360 }
//        argLabel.text = String(format:"%.6f",arg)
        
        //        let northDir: CLLocationDirection =
        //            (northSwitch.selectedSegmentIndex == 0) ? newHeading.magneticHeading : newHeading.trueHeading
        
        let northDir: CLLocationDirection = newHeading.trueHeading
        
        
        //        compassFG.transform = CGAffineTransformMakeRotation(CGFloat(-northDir * M_PI/180))
        
//        dirLabel.text = String(format:"%.6f",northDir)
        
        self.nowAngle = northDir
        
        serachPlace()
        
        
    }
    
    
    struct Point {
        var x:Double = 0
        var y:Double = 0
    }
    
    func angle(a:Point, b:Point) -> Double {
        var r = atan2(b.y - a.y, b.x - a.x)
        if r < 0 {
            r = r + 2 * M_PI
        }
        return floor(r * 360 / (2 * M_PI))
    }
    
    
    
    
    func distance(a:Point, b:Point) -> Double {
        return sqrt(pow(b.x - a.x, 2) + pow(b.y - a.y, 2))
    }
    
    
    
    
    func AngularDeviation(angle1:Double,angle2:Double) -> Double{
        
        
        let deviation1 = fabs(angle1 - angle2)
        
        let deviation2 = fabs(angle1 + (360 - angle2))
        
        if deviation1 > deviation2{
            
            return deviation2
        }else if deviation2 > deviation1 {
            
            return deviation1
        }else {
            
            return deviation1
        }
        
    }
    
    
    
    
    func appendDistance(loadData:[GMSPlaceLikelihood]) {
        
        var i = 0
        
        DataArray = Array<Array<Any>>()
        
        for element in loadData{
            
            
//            print(element.place.name)
            
            
            
            var coordinate_distance = distance(a:  Point(x: self.latitude, y: self.longitude),
                                               b: Point(x: Double(element.place.coordinate.latitude),
                                                        y: Double(element.place.coordinate.longitude)))
            
//            print("distance")
//            print(coordinate_distance)
            
            self.DataArray.append([element.place.name,
                                   Double(coordinate_distance), Double(element.place.coordinate.latitude), Double(element.place.coordinate.longitude) ])
            
            i += 1
            
        }
        
        
        //        print(self.DataArray.sorted(by: { $0[1] as? Double > $1[1] as? Double } ))
        
        self.DataArray = self.bubblesor2(&DataArray)
//        print("DataArray :")
//        print(self.DataArray)
        
        
        
        
    }
    
    
    
    
    func bubblesor2(_ a:inout Array<Array<Any>>) -> Array<Array<Any>>{
        
        for j in (0...a.count - 1){
            
            for i in (0..<a.count - j - 1){
                
                if Double(a[i][1] as! Double) > Double(a[i + 1][1] as! Double){
                    swap(&a[i], &a[i + 1])
                }
                
            }
            
        }
        
        return a
        
    }

    
    
    
}
