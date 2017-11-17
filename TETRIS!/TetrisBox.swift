//
//  TetrisBox.swift
//  TETRIS!
//
//  Created by Joao Pedro Xavier on 16/11/17.
//  Copyright © 2017 Joao Pedro Xavier. All rights reserved.
//

import Foundation
import SceneKit

let boxLength = CGFloat(0.01)
let boxWidth = CGFloat(0.5)
let boxHeight = CGFloat(0.6)
let offset = CGFloat(0.02)
let epsilon = CGFloat(0.005)

class TetrisBox {
    
    let floorNode = SCNNode(geometry: SCNBox(width: boxWidth, height: offset, length: boxLength + offset, chamferRadius: 0))
    let ceilNode = SCNNode(geometry: SCNBox(width: boxWidth, height: offset, length: boxLength + offset, chamferRadius: 0))
    let leftWallNode = SCNNode(geometry: SCNBox(width: offset, height: boxHeight, length: boxLength, chamferRadius: 0))
    let rightWallNode = SCNNode(geometry: SCNBox(width: offset, height: boxHeight, length: boxLength, chamferRadius: 0))
    let frontWallNode = SCNNode(geometry: SCNBox(width: boxWidth, height: boxHeight, length: offset, chamferRadius: 0))
    let backWallNode = SCNNode(geometry: SCNBox(width: boxWidth, height: boxHeight, length: offset, chamferRadius: 0))
    
    init() {
        setNode(floorNode, 0.0, 0.0, 0.0)
        setNode(ceilNode, 0.0, boxHeight, 0.0)
        setNode(leftWallNode, boxWidth / 2, boxHeight / 2, 0.0)
        setNode(rightWallNode, -boxWidth / 2, boxHeight / 2, 0.0)
        setNode(frontWallNode, 0.0, boxHeight / 2, boxLength/2 + offset + epsilon)
        setNode(backWallNode, 0.0, boxHeight / 2, -(boxLength/2 + offset + epsilon) )
    }
    
    func setNode(_ node: SCNNode, _ x: CGFloat, _ y: CGFloat, _ z: CGFloat) {
        node.position = SCNVector3(x, y, z)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        node.geometry?.firstMaterial?.transparency = CGFloat(0.1)
        node.physicsBody = SCNPhysicsBody.kinematic()
    }
}