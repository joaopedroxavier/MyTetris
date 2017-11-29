//
//  ViewController.swift
//  TETRIS!
//
//  Created by Joao Pedro Xavier on 26/10/17.
//  Copyright © 2017 Joao Pedro Xavier. All rights reserved.
//

import UIKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate, SCNPhysicsContactDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    var gameFloorNode : SCNNode?
    var currentPiece : TetrisPiece?
    var foundGamePlane = false
    var lastUpdateTime = 0.0
    
    var audioPlayer : AVAudioPlayer?
    
    //First things first
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.scene.physicsWorld.gravity = SCNVector3(+0.0, -0.0, +0.0)
        sceneView.scene.physicsWorld.contactDelegate = self
        
        configuration.planeDetection = .horizontal
        
        showMessage("Looking for plane surfaces...")
        
        hidePlayButton()
        
        prepareBackgroundMusic()
        
        let rightSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didRightSwipe(_:)))
        rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.right
        sceneView.addGestureRecognizer(rightSwipeGestureRecognizer)
        
        let leftSwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didLeftSwipe(_:)))
        leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
        sceneView.addGestureRecognizer(leftSwipeGestureRecognizer)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showMessage(_ message: String) {
        DispatchQueue.main.async{
            self.messageLabel.text = message
            self.messageLabel.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.messageLabel.isHidden = true
        }
    }
    
    //#######################    Plane Detection and Label Update   ####################################
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        showMessage("Plane detected!")
        showPlayButton()
        
        let floorNode = createFloor(on: planeAnchor)
        if(!foundGamePlane) { gameFloorNode = node }
        
        node.addChildNode(floorNode.floorNode)
        node.addChildNode(floorNode.ceilNode)
        node.addChildNode(floorNode.leftWallNode)
        node.addChildNode(floorNode.rightWallNode)
        node.addChildNode(floorNode.frontWallNode)
        node.addChildNode(floorNode.backWallNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        let floorNode = createFloor(on: planeAnchor)
        
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        if(!foundGamePlane) { gameFloorNode = node }

        node.addChildNode(floorNode.floorNode)
        node.addChildNode(floorNode.ceilNode)
        node.addChildNode(floorNode.leftWallNode)
        node.addChildNode(floorNode.rightWallNode)
        node.addChildNode(floorNode.frontWallNode)
        node.addChildNode(floorNode.backWallNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        guard let _ = anchor as? ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        if sceneView.scene.rootNode.childNodes.isEmpty == true {
            hidePlayButton()
            showMessage("Looking for plane surfaces...")
        }
    }
    
    func createFloor(on planeAnchor: ARPlaneAnchor) -> TetrisBox {
        return TetrisBox()
    }
    
    //#######################    Game Setup   ####################################
    
    func showPlayButton() {
        DispatchQueue.main.async {
            self.playButton.isHidden = false
        }
    }
    
    func hidePlayButton() {
        DispatchQueue.main.async {
            self.playButton.isHidden = true
        }
    }
    
    @IBAction func playGame(_ sender: Any) {
        addBlock()
    }
    
    func addBlock() {
        guard let gamePlaneNode = gameFloorNode else { return }
        
        if(!foundGamePlane) {
            gameFloorNode = gamePlaneNode.copy() as? (SCNNode)
            foundGamePlane = true
            sceneView.scene.rootNode.addChildNode(gameFloorNode!)
        }
        
        let pieceNode = TetrisPiece()
        currentPiece = pieceNode
        
        for blockNode in pieceNode.pieces { gameFloorNode?.addChildNode(blockNode) }
        
    }
    
    //#######################    Gameplay   ####################################
    
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        guard let gameCurrentPiece = currentPiece else { return }
        
        let firstNode = contact.nodeA
        let secondNode = contact.nodeB
        
        var willCreateBlock = false
        
        if(firstNode.name == "gameOverSide" && (secondNode.name == "NonStuck" || secondNode.name == "Stuck")) { resetGame(lost: true); return }
        if((secondNode.name == "NonStuck" || secondNode.name == "Stuck") && secondNode.name == "gameOverSide") { resetGame(lost: true); return }
        
        if(firstNode.name == "NonStuck") {
            //firstNode.name = "Stuck"
            if let thisBlock = firstNode as? TetrisBlock {
                if let piece = thisBlock.piece {
                    if(gameCurrentPiece.pieces[0].position == piece.pieces[0].position) { willCreateBlock = true }
                    for block in piece.pieces {
                        if(block.position.y <= thisBlock.position.y){
                            block.name = "Stuck"
                        }
                    }
                }
            }
        }
        
        if(secondNode.name == "NonStuck") {
            //secondNode.name = "Stuck"
            if let thisBlock = secondNode as? TetrisBlock {
                if let piece = thisBlock.piece {
                    if(gameCurrentPiece.pieces[0].position == piece.pieces[0].position) { willCreateBlock = true }
                    for block in piece.pieces {
                        if(block.position.y <= thisBlock.position.y){
                            block.name = "Stuck"
                        }
                    }
                }
            }
        }
        
        if(willCreateBlock) { addBlock() }
    }
    
    @objc
    func didRightSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard gesture.state == .ended else { return }
        if let piece = currentPiece {
            piece.moveRight()
        }
    }
    
    @objc
    func didLeftSwipe(_ gesture: UISwipeGestureRecognizer) {
        guard gesture.state == .ended else { return }
        if let piece = currentPiece {
            piece.moveLeft()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if(time - lastUpdateTime >= 0.1) {
            lastUpdateTime = time
            sceneView.scene.rootNode.enumerateChildNodes { (childNode, _) in
                if(childNode.name == "NonStuck") { childNode.position.y -= 0.01 }
                if(childNode.name == "Stuck") {
                    childNode.physicsBody?.velocity = SCNVector3(0.0, 0.0, 0.0)
                    if (childNode.position.y - Float(ceil(childNode.position.y * 50)) / 50 != 0) {
                        childNode.position.y = Float(ceil(childNode.position.y * 50)) / 50
                    }
                }
            }
        }
    }
    
    //#######################    Handling background music   ####################################
    
    func prepareBackgroundMusic() {
        guard let filePath = Bundle.main.path(forResource: "Tetris", ofType: "mp3") else { return }
        
        let fileURL = URL(fileURLWithPath: filePath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.prepareToPlay()
        } catch {
            print("Couldn't play the song.")
        }
    }
    
    @IBAction func pauseBackgroundMusic(_ sender: Any) {
        if audioPlayer!.isPlaying {
            audioPlayer?.pause()
        } else {
            
        }
    }
    
    @IBAction func playBackgroundMusic(_ sender: Any) {
        audioPlayer?.play()
    }
    
    @IBAction func restartBackgroundMusic(_ sender: Any) {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }
    
    //#######################    Restart AR Session   ####################################
    
    @IBAction func restartSession(_ sender: Any) {  resetGame(lost: false)  }
    
    func resetGame(lost: Bool) {
        if(lost) {
            showMessage("You lost! :(")
        } else {
            showMessage("Reinitializing session...")
        }
        hidePlayButton()
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        foundGamePlane = false
        showMessage("Looking for plane surfaces...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

func + (lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 { return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z); }

func == (lhs: SCNVector3, rhs: SCNVector3) -> Bool { return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z }

extension Int {
    func toRadians() -> Double { return Double(self) * 2 * Double.pi / 360 }
}
