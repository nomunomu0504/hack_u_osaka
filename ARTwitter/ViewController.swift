//
//  ViewController.swift
//  ARTwitter
//
//  Created by みさきまさし on 2017/08/10.
//  Copyright © 2017年 arsjam. All rights reserved.
//

import UIKit
import GooglePlaces
import CoreLocation

class ViewController: UIViewController,  CLLocationManagerDelegate  {

    
    var placesClient: GMSPlacesClient!
    
    // Add a pair of UILabels in Interface Builder, and connect the outlets to these variables.
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    
    var google_load_flag = false
    
    var longitude:Double = 0
    var latitude :Double = 0
    
    var nowAngle:Double = 0
    
    var DataArray = Array<Array<Any>>()
    
    var data_GMSPlaceLikelihood = Array<GMSPlaceLikelihood>()
    
    
    var alertFlag = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        placesClient = GMSPlacesClient.shared()
        
        
        var names = [[1],[5],[3],[2]]
    
//        var reversedNames = names.sorted(by: { &s1[0], &s2[0] in &s1[0] > &s2[0] } )
        var reversedNames = names.sorted(by: { $0[0] > $1[0] } )
        
        print("sorted \(reversedNames)")
    }
    
    // Add a UIButton in Interface Builder, and connect the action to this function.
    @IBAction func getCurrentPlace(_ sender: UIButton) {
        
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            self.nameLabel.text = "No current place"
            self.addressLabel.text = ""
            
//            print("place list")
//            print("\(String(describing: placeLikelihoodList!.likelihoods[1]))")
            
            print("place list count")
            print("\(String(describing: placeLikelihoodList!.likelihoods.count))")
            
            
            self.data_GMSPlaceLikelihood = placeLikelihoodList!.likelihoods
            
            self.appendDistance(loadData: self.data_GMSPlaceLikelihood)

            
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                
                self.google_load_flag = true
                
                
//                if let place = place {
//                    self.nameLabel.text = place.name
//                    print("cordinate2D")
//                    print(place.coordinate)
//
//                    print("longitude \(Double(place.coordinate.longitude))")
//
//
//
//
////                    self.latitude = Double(place.coordinate.latitude)
////                    self.longitude = Double(place.coordinate.longitude)
//
//
//                }
            }
        })
    }
    
    
    
    @IBAction func Next(_ sender: Any) {
    
        
        // 次の遷移先のViewControllerインスタンスを生成する
        let vc = CameraViewContoller()
        
        // presentViewControllerメソッドで遷移する
        // ここで、animatedをtrueにするとアニメーションしながら遷移できる
        self.present(vc, animated: true, completion: nil) //swift4
        
//      self.presentViewController(vc, animated: true, completion: nil) //swift3
    
    
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var lngLabel: UILabel!
    @IBOutlet weak var altLabel: UILabel!
    @IBOutlet weak var argLabel: UILabel!
    @IBOutlet weak var dirLabel: UILabel!
    @IBOutlet weak var northSwitch: UISegmentedControl!
//    @IBOutlet weak var compassFG: UIImageView!
    
    let lm = CLLocationManager()
    
    @IBAction func tapStart(sender: AnyObject) {
        disabledLocationLabel()
        lm.requestWhenInUseAuthorization()
        lm.delegate = self
        startLocationService()
        startHeadingService()
    }
    
    @IBAction func tapStop(sender: AnyObject) {
        lm.stopUpdatingLocation()
        lm.stopUpdatingHeading()
    }
    
    
    
    
    
    
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
        let locationData = locations.last
        if let lng = locationData?.coordinate.longitude {
            lngLabel.text = String(format:"%.6f",lng)
        }
        if let lat = locationData?.coordinate.latitude {
            latLabel.text = String(format:"%.6f",lat)
        }
        if let alt = locationData?.altitude {
            altLabel.text = String(format:"%.6f",alt)
        }
        
        if self.google_load_flag == true {
            
            print("location latitude: \(Double(locationData!.coordinate.latitude)) location longitude: \(Double(locationData!.coordinate.longitude))")
//            print("latitude: \(self.latitude) longitude: \(self.longitude)")
            
            //35.9304939,136.1857218,15 サンドーム
            
//            print(angle(a:Point(x: Double(locationData!.coordinate.latitude), y: Double(locationData!.coordinate.longitude)),
//                        b: Point(x: self.latitude, y: self.longitude)))
            
            
            
            self.latitude = Double(locationData!.coordinate.latitude) //現在の位置
            
            self.longitude = Double(locationData!.coordinate.longitude) //現在の位置
            
            
            self.appendDistance(loadData: self.data_GMSPlaceLikelihood)
            
            
//            self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
//                .joined(separator: "\n")
            
            

            
            
            let angle_:Double = angle(a: Point(x: self.latitude, y: self.longitude),
                                      b: Point(x: Double(self.DataArray[0][2] as! Double),
                                               y: Double(self.DataArray[0][3] as! Double)) //ここを変更
            )
            
            
            self.nameLabel.text = self.DataArray[0][0] as! String
            
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
    
    
    
    
    func startHeadingService() {
        northSwitch.selectedSegmentIndex = 0
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
        lngLabel.text = msg
        latLabel.text = msg
        altLabel.text = msg
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
        argLabel.text = String(format:"%.6f",arg)
        
//        let northDir: CLLocationDirection =
//            (northSwitch.selectedSegmentIndex == 0) ? newHeading.magneticHeading : newHeading.trueHeading
        
        let northDir: CLLocationDirection = newHeading.trueHeading
        
        
//        compassFG.transform = CGAffineTransformMakeRotation(CGFloat(-northDir * M_PI/180))
        
        dirLabel.text = String(format:"%.6f",northDir)
        
        self.nowAngle = northDir

        
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
            
            
            print(element.place.name)
            
            
            
            var coordinate_distance = distance(a:  Point(x: self.latitude, y: self.longitude),
                                               b: Point(x: Double(element.place.coordinate.latitude),
                                                        y: Double(element.place.coordinate.longitude)))
            
            print("distance")
            print(coordinate_distance)
            
            self.DataArray.append([element.place.name,
                                   Double(coordinate_distance), Double(element.place.coordinate.latitude), Double(element.place.coordinate.longitude) ])
            
            i += 1
            
        }
        
        
        //        print(self.DataArray.sorted(by: { $0[1] as? Double > $1[1] as? Double } ))
        
        self.DataArray = self.bubblesor2(&DataArray)
        print("DataArray :")
        print(self.DataArray)
        
        
        
        
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

