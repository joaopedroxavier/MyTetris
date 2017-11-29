//
//  TetrisBlock.swift
//  TETRIS!
//
//  Created by Joao Pedro Xavier on 31/10/17.
//  Copyright © 2017 Joao Pedro Xavier. All rights reserved.
//

import Foundation
import SceneKit

class TetrisBlock : SCNNode{
    var blocksLeft = 0
    var blocksRight = 0
    var piece : TetrisPiece?
    
    override init() {
        super.init()
        self.geometry = SCNSphere(radius: 0.01)
        self.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        self.physicsBody = SCNPhysicsBody.dynamic()
        self.physicsBody?.physicsShape = SCNPhysicsShape(geometry: SCNBox(width: 0.02, height: 0.02, length: 0.02, chamferRadius: 0))
        self.name = "NonStuck"
        self.physicsBody?.contactTestBitMask = 0x000000F0
        self.physicsBody?.collisionBitMask = 0x000000F0
        self.physicsBody?.categoryBitMask = 0x000000F0
        self.physicsBody?.mass = 0.001
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
