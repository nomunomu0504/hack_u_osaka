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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        placesClient = GMSPlacesClient.shared()
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
            
            print("place list")
            print("\(String(describing: placeLikelihoodList!.likelihoods))")
            
            print("place list count")
            print("\(String(describing: placeLikelihoodList!.likelihoods.count))")
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.nameLabel.text = place.name
                    self.addressLabel.text = place.formattedAddress?.components(separatedBy: ", ")
                        .joined(separator: "\n")
                }
            }
        })
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
        
    }

}

