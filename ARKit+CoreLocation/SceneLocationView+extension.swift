////
////  SceneLocationView+extension.swift
////  ARKit+CoreLocation
////
////  Created by みさきまさし on 2017/08/16.
////  Copyright © 2017年 Project Dent. All rights reserved.
////
//
//import Foundation
//import ARKit
//import CoreLocation
//import MapKit
//
//
//
//public extension SceneLocationView {
//
//
//
////    var updateEstimatesTimer2: Timer?
//
//
//
//
//    public func runForCoustom() {
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = .horizontal
//
//        if orientToTrueNorth {
//            configuration.worldAlignment = .gravityAndHeading
//        } else {
//            configuration.worldAlignment = .gravity
//        }
//
//        // Run the view's session
//        session.run(configuration)
//
//        updateEstimatesTimer2!.invalidate()
//        updateEstimatesTimer2 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(SceneLocationView.updateLocationDataForCoustom), userInfo: nil, repeats: true)
//    }
//
//
//
//
//    @objc private func updateLocationDataForCoustom() {
//
//        updatePositionAndScaleOfLocationNodesForCoustom()
//    }
//
//    func updatePositionAndScaleOfLocationNodesForCoustom() {
//        for locationNode in locationNodes {
//            if locationNode.continuallyUpdatePositionAndScale {
//                updatePositionAndScaleOfLocationNodeForCoustom(locationNode: locationNode, animated: true)
//            }
//        }
//    }
//
//
//    public func updatePositionAndScaleOfLocationNodeForCoustom(locationNode: LocationNode, initialSetup: Bool = false, animated: Bool = false, duration: TimeInterval = 0.1) {
//        guard let currentPosition = currentScenePosition(),
//            let currentLocation = currentLocation() else {
//                return
//        }
//
//        SCNTransaction.begin()
//
//        if animated {
//            SCNTransaction.animationDuration = duration
//        } else {
//            SCNTransaction.animationDuration = 0
//        }
//
//        let locationNodeLocation = locationOfLocationNode(locationNode)
//
//        //Position is set to a position coordinated via the current position
//        let locationTranslation = currentLocation.translation(toLocation: locationNodeLocation)
//
//
//        let adjustedDistance: CLLocationDistance
//
//        let distance = locationNodeLocation.distance(from: currentLocation)
//
//        if locationNode.locationConfirmed &&
//            (distance > 100 || locationNode.continuallyAdjustNodePositionWhenWithinRange || initialSetup) {
//            if distance > 100 {
//                //If the item is too far away, bring it closer and scale it down
//                let scale = 100 / Float(distance)
//
//                adjustedDistance = distance * Double(scale)
//
//                let adjustedTranslation = SCNVector3(
//                    x: Float(locationTranslation.longitudeTranslation) * scale,
//                    y: Float(locationTranslation.altitudeTranslation) * scale,
//                    z: Float(locationTranslation.latitudeTranslation) * scale)
//
//                let position = SCNVector3(
//                    x: currentPosition.x + adjustedTranslation.x,
//                    y: currentPosition.y + adjustedTranslation.y,
//                    z: currentPosition.z - adjustedTranslation.z)
//
//                locationNode.position = position
//
//                locationNode.scale = SCNVector3(x: scale, y: scale, z: scale)
//            } else {
//                adjustedDistance = distance
//                let position = SCNVector3(
//                    x: currentPosition.x + Float(locationTranslation.longitudeTranslation),
//                    y: currentPosition.y + Float(locationTranslation.altitudeTranslation),
//                    z: currentPosition.z - Float(locationTranslation.latitudeTranslation))
//
//                locationNode.position = position
//                locationNode.scale = SCNVector3(x: 1, y: 1, z: 1)
//            }
//        } else {
//            //Calculates distance based on the distance within the scene, as the location isn't yet confirmed
//            adjustedDistance = Double(currentPosition.distance(to: locationNode.position))
//
//            locationNode.scale = SCNVector3(x: 1, y: 1, z: 1)
//        }
//
//
//
//        if let annotationNode = locationNode as? LocationAnnotationNode  {
//            //The scale of a node with a billboard constraint applied is ignored
//            //The annotation subnode itself, as a subnode, has the scale applied to it
//            let appliedScale = locationNode.scale
//            locationNode.scale = SCNVector3(x: 1, y: 1, z: 1)
//
//            var scale: Float
//
//            if annotationNode.scaleRelativeToDistance {
//                scale = appliedScale.y
//                annotationNode.annotationNode.scale = appliedScale
//            } else {
//                //Scale it to be an appropriate size so that it can be seen
//                scale = Float(adjustedDistance) * 0.181
//
//                if distance > 3000 {
//                    scale = scale * 0.75
//                }
//
//                annotationNode.annotationNode.scale = SCNVector3(x: scale, y: scale, z: scale)
//            }
//
//            annotationNode.pivot = SCNMatrix4MakeTranslation(0, -1.1 * scale, 0)
//        }
//
//
//
//        if let annotationNode2 = locationNode as? CreateSampleObjectAR  {
//            //The scale of a node with a billboard constraint applied is ignored
//            //The annotation subnode itself, as a subnode, has the scale applied to it
//            let appliedScale = locationNode.scale
//            locationNode.scale = SCNVector3(x: 1, y: 1, z: 1)
//
//            var scale: Float
//
//            if annotationNode2.scaleRelativeToDistance {
//                scale = appliedScale.y
//                annotationNode2.annotationNode.scale = appliedScale
//            } else {
//                //Scale it to be an appropriate size so that it can be seen
//                scale = Float(adjustedDistance) * 0.181
//
//                if distance > 3000 {
//                    scale = scale * 0.75
//                }
//
//                annotationNode2.annotationNode.scale = SCNVector3(x: scale, y: scale, z: scale)
//            }
//
//            annotationNode2.pivot = SCNMatrix4MakeTranslation(0, -1.1 * scale, 0)
//        }
//
//
//
//
//        SCNTransaction.commit()
//
//        locationDelegate?.sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: self, locationNode: locationNode)
//    }
//
//
//
//
//}
//
