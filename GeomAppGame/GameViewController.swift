//
//  GameViewController.swift
//  GeomAppGame
//
//  Created by Joshua McFarlin on 8/22/17.
//  Copyright © 2017 Joshua McFarlin. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

struct Variables {
    static var scene = SCNScene()
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        Variables.scene.rootNode.addChildNode(cameraNode)

        // set camera position
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        let scnView = self.view as! SCNView
        scnView.scene = Variables.scene
        scnView.autoenablesDefaultLighting = true
        scnView.allowsCameraControl = true
        scnView.showsStatistics = false
        scnView.backgroundColor = UIColor.black
    }

    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
