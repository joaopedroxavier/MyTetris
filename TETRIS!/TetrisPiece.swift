//
//  TetrisPiece.swift
//  TETRIS!
//
//  Created by Joao Pedro Xavier on 20/11/17.
//  Copyright © 2017 Joao Pedro Xavier. All rights reserved.
//

import Foundation
import SceneKit

let dist = 0.025
let rise = 0.5

func mountI(_ blocks: [TetrisBlock]) {
    blocks[0].position = SCNVector3(0.0, rise + dist / 2, 0.0)
    blocks[1].position = SCNVector3(0.0, rise - dist / 2, 0.0)
    blocks[2].position = SCNVector3(0.0, rise + 3 * dist / 2, 0.0)
    blocks[3].position = SCNVector3(0.0, rise - 3 * dist / 2, 0.0)
}

func mountO(_ blocks: [TetrisBlock]) {
    blocks[0].position = SCNVector3(dist, rise + dist / 2, 0.0)
    blocks[1].position = SCNVector3(0.0, rise + dist / 2, 0.0)
    blocks[2].position = SCNVector3(dist, rise - dist / 2, 0.0)
    blocks[3].position = SCNVector3(0.0, rise - dist / 2, 0.0)
}

func mountS(_ blocks: [TetrisBlock]) {
    blocks[0].position = SCNVector3(-dist, rise - dist / 2, 0.0)
    blocks[1].position = SCNVector3(0.0, rise - dist / 2, 0.0)
    blocks[2].position = SCNVector3(0.0, rise + dist / 2, 0.0)
    blocks[3].position = SCNVector3(dist, rise + dist / 2, 0.0)
}

func mountZ(_ blocks: [TetrisBlock]) {
    blocks[0].position = SCNVector3(dist, rise - dist / 2, 0.0)
    blocks[1].position = SCNVector3(0.0, rise - dist / 2, 0.0)
    blocks[2].position = SCNVector3(0.0, rise + dist / 2, 0.0)
    blocks[3].position = SCNVector3(-dist, rise + dist / 2, 0.0)
}

func mountT(_ blocks: [TetrisBlock]) {
    blocks[0].position = SCNVector3(-dist, rise + dist / 2, 0.0)
    blocks[1].position = SCNVector3(0.0, rise - dist / 2, 0.0)
    blocks[2].position = SCNVector3(0.0, rise + dist / 2, 0.0)
    blocks[3].position = SCNVector3(dist, rise + dist / 2, 0.0)}

func mountJ(_ blocks: [TetrisBlock]) {
    blocks[0].position = SCNVector3(-dist, rise - dist / 2, 0.0)
    blocks[1].position = SCNVector3(0.0, rise - dist / 2, 0.0)
    blocks[2].position = SCNVector3(0.0, rise + dist / 2, 0.0)
    blocks[3].position = SCNVector3(0.0, rise + 3 * dist / 2, 0.0)
}

func mountL(_ blocks: [TetrisBlock]) {
    blocks[0].position = SCNVector3(dist, rise - dist / 2, 0.0)
    blocks[1].position = SCNVector3(0.0, rise - dist / 2, 0.0)
    blocks[2].position = SCNVector3(0.0, rise + dist / 2, 0.0)
    blocks[3].position = SCNVector3(0.0, rise + 3 * dist / 2, 0.0)
}

class TetrisPiece {
    var pieces = [TetrisBlock]()
    let center = SCNNode()
    
    var mountBlockType : Dictionary<Int, ([TetrisBlock]) -> Void > = [
        0 : mountI,
        1 : mountO,
        2 : mountS,
        3 : mountZ,
        4 : mountT,
        5 : mountJ,
        6 : mountL
    ]
    
    init() {
        pieces.append(TetrisBlock())
        pieces.append(TetrisBlock())
        pieces.append(TetrisBlock())
        pieces.append(TetrisBlock())
        
        for i in 0...3 { pieces[i].piece = self }
        
        let typeChosen = Int(arc4random_uniform(7))
        if let mountBlock = mountBlockType[typeChosen] {
            mountBlock(pieces)
        }
    }
    
    func moveLeft() {
        for block in pieces{ block.position.x -= Float(dist) }
    }
    
    func moveRight() {
        for block in pieces{ block.position.x += Float(dist) }
    }
}
