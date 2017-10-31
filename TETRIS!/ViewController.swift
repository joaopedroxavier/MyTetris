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
    @IBOutlet weak var planeDetectedLabel: UILabel!
    
    let configuration = ARWorldTrackingConfiguration()
    
    var audioPlayer : AVAudioPlayer?
    
    //First things first
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.run(configuration)
        sceneView.delegate = self
        
        configuration.planeDetection = .horizontal
        planeDetectedLabel.isHidden = false
        planeDetectedLabel.text = "Looking for plane surfaces..."
        
        prepareBackgroundMusic()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        DispatchQueue.main.async{
            self.planeDetectedLabel.text = "Plane detected!"
            self.planeDetectedLabel.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.planeDetectedLabel.isHidden = true
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
    
    //########################################################################################
    
    @IBAction func restartSession(_ sender: Any) {
        sceneView.session.pause()
        sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

