//
//  TetrisBox.swift
//  TETRIS!
//
//  Created by Joao Pedro Xavier on 16/11/17.
//  Copyright © 2017 Joao Pedro Xavier. All rights reserved.
//

import Foundation
import SceneKit

let boxLength = CGFloat(0.02)
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
        setNode(floorNode, 0.0, 0.0, 0.0, "BoxSide")
        setNode(ceilNode, 0.0, boxHeight, 0.0, "gameOverSide")
        setNode(leftWallNode, boxWidth / 2, boxHeight / 2, 0.0, "BoxSide")
        setNode(rightWallNode, -boxWidth / 2, boxHeight / 2, 0.0, "BoxSide")
        setNode(frontWallNode, 0.0, boxHeight / 2, boxLength/2 + offset + epsilon, "BoxSide")
        setNode(backWallNode, 0.0, boxHeight / 2, -(boxLength/2 + offset + epsilon), "BoxSide")
    }
    
    func setNode(_ node: SCNNode, _ x: CGFloat, _ y: CGFloat, _ z: CGFloat, _ name: String) {
        node.position = SCNVector3(x, y, z)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        node.geometry?.firstMaterial?.transparency = CGFloat(0.1)
        node.physicsBody = SCNPhysicsBody.kinematic()
        node.physicsBody?.contactTestBitMask = 0x000000F0
        node.physicsBody?.collisionBitMask = 0x000000F0
        node.physicsBody?.categoryBitMask = 0x000000F0
        node.name = name
    }
}
