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
        sprite.position = SCNVector3(0.0, 0.5, 0.0)
        sprite.physicsBody = SCNPhysicsBody.dynamic()
        sprite.physicsBody?.mass = 0.5
    }
}
