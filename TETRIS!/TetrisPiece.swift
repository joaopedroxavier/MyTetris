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

func mountColumn(_ blocks: [TetrisBlock]) {
    blocks[0].sprite.position = SCNVector3(0.0, rise + dist / 2, 0.0)
    blocks[1].sprite.position = SCNVector3(0.0, rise - dist / 2, 0.0)
    blocks[2].sprite.position = SCNVector3(0.0, rise + 3 * dist / 2, 0.0)
    blocks[3].sprite.position = SCNVector3(0.0, rise - 3 * dist / 2, 0.0)
}

class TetrisPiece {
    var pieces = [TetrisBlock]()
    let center = SCNNode()
    
    init() {
        pieces.append(TetrisBlock())
        pieces.append(TetrisBlock())
        pieces.append(TetrisBlock())
        pieces.append(TetrisBlock())
        mountColumn(pieces)
    }
}
