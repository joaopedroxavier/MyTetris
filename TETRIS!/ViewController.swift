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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    var gameFloorNode : SCNNode?
    var foundGamePlane = false
    
    var audioPlayer : AVAudioPlayer?
    
    //First things first
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        sceneView.scene.physicsWorld.gravity = SCNVector3(+0.0, -2.0, +0.0)
        
        configuration.planeDetection = .horizontal
        
        showMessage("Looking for plane surfaces...")
        
        hidePlayButton()
        
        prepareBackgroundMusic()
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
        //let floorNode = SCNNode(geometry: SCNBox(width: CGFloat(planeAnchor.extent.x), height: CGFloat(0.05), length: CGFloat(planeAnchor.extent.z), chamferRadius: 0))
        let floorNode = TetrisBox()
        
        /*
        floorNode.physicsBody = SCNPhysicsBody.kinematic()
        
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        */
 
        return floorNode
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
    
    @IBAction func addBlock(_ sender: Any) {
        guard let gamePlaneNode = gameFloorNode else { return }
        
        if(!foundGamePlane) {
            gameFloorNode = gamePlaneNode.copy() as? (SCNNode)
            foundGamePlane = true
            sceneView.scene.rootNode.addChildNode(gameFloorNode!)
        }
        
        let blockNode = TetrisBlock()
        gameFloorNode?.addChildNode(blockNode.sprite)
        
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
    
    @IBAction func restartSession(_ sender: Any) {
        showMessage("Reinitializing session...")
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

extension Int {
    func toRadians() -> Double { return Double(self) * 2 * Double.pi / 360 }
}
