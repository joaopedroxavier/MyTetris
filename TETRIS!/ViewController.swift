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
    
    var audioPlayer : AVAudioPlayer?
    
    //First things first
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        
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
        
        node.addChildNode(floorNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        
        let floorNode = createFloor(on: planeAnchor)
        
        node.addChildNode(floorNode)
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
    
    func createFloor(on planeAnchor: ARPlaneAnchor) -> SCNNode {
        let floorNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        
        floorNode.geometry?.firstMaterial?.diffuse.contents = UIColor.darkGray
        floorNode.geometry?.firstMaterial?.isDoubleSided = true
        floorNode.position = SCNVector3(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z)
        floorNode.eulerAngles = SCNVector3(90.toRadians(), 0, 0)
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
        showMessage("Looking for plane surfaces...")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension Int {
    func toRadians() -> Double { return Double(self) * 2 * Double.pi / 360 }
}
