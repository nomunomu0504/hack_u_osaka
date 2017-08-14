//
//  CreateObjectAR.swift
//  ARKit+CoreLocation
//
//  Created by みさきまさし on 2017/08/15.
//  Copyright © 2017年 Project Dent. All rights reserved.
//

import Foundation
import SceneKit
import CoreLocation


open class CreateObjectAR: LocationNode {
    ///An image to use for the annotation
    ///When viewed from a distance, the annotation will be seen at the size provided
    ///e.g. if the size is 100x100px, the annotation will take up approx 100x100 points on screen.
    public let image: UIImage
    
    ///Subnodes and adjustments should be applied to this subnode
    ///Required to allow scaling at the same time as having a 2D 'billboard' appearance
    public let annotationNode: SCNNode
    public let annotationNode_text: SCNNode

    
    public let text: SCNText
    
    ///Whether the node should be scaled relative to its distance from the camera
    ///Default value (false) scales it to visually appear at the same size no matter the distance
    ///Setting to true causes annotation nodes to scale like a regular node
    ///Scaling relative to distance may be useful with local navigation-based uses
    ///For landmarks in the distance, the default is correct
    public var scaleRelativeToDistance = false
    
    public init(location: CLLocation?, image: UIImage) {
        
        
        // SCNText
        text = SCNText()
        
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
        
        text.firstMaterial!.diffuse.contents = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
        text.firstMaterial!.lightingModel = .constant
        

        annotationNode_text = SCNNode()
        annotationNode_text.geometry = text
        self.annotationNode_text.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
        
        self.image = image
        
        let plane = SCNPlane(width: image.size.width / 200, height: image.size.height / 200)
        plane.firstMaterial!.diffuse.contents = image
        plane.firstMaterial!.lightingModel = .constant
        
        annotationNode = SCNNode()
        annotationNode.geometry = plane
        
        super.init(location: location)
        
        let billboardConstraint = SCNBillboardConstraint()
        billboardConstraint.freeAxes = SCNBillboardAxis.Y
        constraints = [billboardConstraint]
        
        addChildNode(annotationNode)
        addChildNode(annotationNode_text)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
