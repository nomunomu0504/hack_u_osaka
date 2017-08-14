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

    
    
    public var scaleRelativeToDistance = false
    
    
    
    public init(location: CLLocation?, image: UIImage) {
        
        
        
        
        // SCNText
        let text = SCNText()
        
        //        text.containerFrame = CGRect(x: -0.5, y: -2, width: 2, height: 4) // 幅を決める
        
        //text.truncationMode = kCATruncationEnd
        //text.alignmentMode = kCAAlignmentCenter
        //text.font = UIFont(name: "Futura-Bold", size: 0.5)
        
        // NSAttributedString 設定
        let style = NSMutableParagraphStyle()
        style.lineSpacing = -0.5
        
        let textFont:UIFont = UIFont(name: "Futura-Bold", size: 0.5)!
        
        
        text.string = NSAttributedString(string: "Hello World!!!", attributes:
            [NSAttributedStringKey.paragraphStyle: style,
             NSAttributedStringKey.font: textFont]
        )
        
        
        // その他の設定
        text.flatness = 0.0
        text.extrusionDepth = 0.1 // テキストの奥行きの幅を設定　デフォルト1
        text.chamferRadius = 0.02
        
        
        // chamfer の形状設定
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0.0, y: 1.0))
        path.addLine(to: CGPoint(x: 0.0, y: 0.75))
        path.addLine(to: CGPoint(x: 0.25, y: 0.75))
        path.addLine(to: CGPoint(x: 0.25, y: 0.5))
        path.addLine(to: CGPoint(x: 0.5, y: 0.5))
        path.addLine(to: CGPoint(x: 0.5, y: 0.25))
        path.addLine(to: CGPoint(x: 0.75, y: 0.25))
        path.addLine(to: CGPoint(x: 0.75, y: 0.0))
        path.addLine(to: CGPoint(x: 1.0, y: 0.0))
        
        text.chamferProfile = path
        
        // マテリアル設定
        
        //        let m1 = SCNMaterial()
        //        let m2 = SCNMaterial()
        //        let m3 = SCNMaterial()
        //
        //        m1.diffuse.contents = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        //        m2.diffuse.contents = UIColor.red
        //        m3.diffuse.contents = UIColor.yellow
        //
        //        text.materials = [m3,m2,m1,m2,m3]
        
        text.firstMaterial!.diffuse.contents = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        
        let node = SCNNode(geometry: text)
        node.position = SCNVector3Zero
        
        
        node.scale = SCNVector3(x: 10, y: 10, z: 10) //SCN Nodeのscaleを変更

        
        
        
        
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
//        addChildNode(annotationNode)
        
        addChildNode(node)

        


        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

