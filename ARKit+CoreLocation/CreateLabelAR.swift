//
//  CreateLabelAR.swift
//  ARKit+CoreLocation
//
//  Created by みさきまさし on 2017/08/14.
//  Copyright © 2017年 Project Dent. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation
import UIKit



open class CreateLabelAR: LocationNode {

    
    
    public let annotationNode: SCNNode
    
    public let arLabel: SCNText
    
//    public let floor: SCNBox

    
    public var scaleRelativeToDistance = false
    
    
    
    public init(location: CLLocation?, image: UIImage) {
        
//        let plane = SCNPlane(width: 10000000, height: 10000000)
////        plane.firstMaterial!.diffuse.contents = image
//        plane.firstMaterial!.lightingModel = .constant
//
//
//
//        self.floor = SCNBox(width: CGFloat(10000), height: 0.0001, length: CGFloat(10000), chamferRadius: 0.0)
//
//        let color: SCNMaterial = SCNMaterial()
//        color.diffuse.contents = UIColor.red
//        color.lightingModel = .constant
//
//        plane.materials = [color]
//
//
//        self.floor.materials = [color]
//
////        let boxShape: SCNPhysicsShape = SCNPhysicsShape(geometry: self.floor, options: nil)
//        let boxNode: SCNNode = SCNNode(geometry: self.floor)
//
//

        
        
        
        // ボタンのサイズを定義.
        let bWidth: CGFloat = 100000
        let bHeight: CGFloat = 100000
        // 配置する座標を定義(画面の中心).
//      let posX: CGFloat = self.view.bounds.width/2 - bWidth/2
//      let posY: CGFloat = self.view.bounds.height/2 - bHeight/2

        
        arLabel = SCNText()
        arLabel.string = "hello"
        arLabel.font = UIFont.systemFont(ofSize: CGFloat(20000))
        arLabel.containerFrame =  CGRect(x: 0, y: 0, width: image.size.width / 100, height: image.size.width / 100)
        
        
        arLabel.firstMaterial!.lightingModel = .constant
        
        annotationNode = SCNNode()
        annotationNode.geometry = arLabel
        
        
        
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        addChildNode(annotationNode)
        


        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

