//
//  TetrisBlock.swift
//  TETRIS!
//
//  Created by Joao Pedro Xavier on 31/10/17.
//  Copyright © 2017 Joao Pedro Xavier. All rights reserved.
//

import Foundation
import SceneKit

class TetrisBlock {
    let sprite = SCNNode(geometry: SCNSphere(radius: 0.01))
    var blocksLeft = 0
    var blocksRight = 0
    
    init() {
        sprite.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        sprite.physicsBody = SCNPhysicsBody.dynamic()
        sprite.physicsBody?.physicsShape = SCNPhysicsShape(geometry: SCNBox(width: 0.02, height: 0.02, length: 0.02, chamferRadius: 0))
        sprite.name = "NonStuck"
        sprite.physicsBody?.contactTestBitMask = 0x000000F0
        sprite.physicsBody?.collisionBitMask = 0x000000F0
        sprite.physicsBody?.categoryBitMask = 0x000000F0
        sprite.physicsBody?.mass = 0.001
    }
}
