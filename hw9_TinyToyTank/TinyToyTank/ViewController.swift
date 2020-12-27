//
//  ViewController.swift
//  TinyToyTank
//
//  Created by nju on 2020/12/21.
//

import UIKit
import RealityKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    var tankAnchor: TinyToyTank._TinyToyTank?
    var isActionPlaying: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the "Box" scene from the "Experience" Reality File
        tankAnchor = try! TinyToyTank.load_TinyToyTank()
        tankAnchor!.turret?.setParent(tankAnchor!.tank, preservingWorldTransform: true)
        tankAnchor?.actions.actionComplete.onAction = {_ in
            self.isActionPlaying = false
        }
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(tankAnchor!)
    }
    
    @IBAction func tankLeftPressed(_ sender: Any) {
        if self.isActionPlaying{
            return
        }
        else{
            self.isActionPlaying = true
        }
        tankAnchor!.notifications.tankLeft.post()
    }
    
    @IBAction func tankForwardPressed(_ sender: Any) {
        if self.isActionPlaying{
            return
        }
        else{
            self.isActionPlaying = true
        }
        tankAnchor!.notifications.tankForward.post()
    }
    
    @IBAction func tankRightPressed(_ sender: Any) {
        if self.isActionPlaying{
            return
        }
        else{
            self.isActionPlaying = true
        }
        tankAnchor!.notifications.tankRight.post()
    }
    
    @IBAction func turretLeftPressed(_ sender: Any) {
        if self.isActionPlaying{
            return
        }
        else{
            self.isActionPlaying = true
        }
        tankAnchor!.notifications.turretLeft.post()
    }
    
    @IBAction func turretRightPressed(_ sender: Any) {
        if self.isActionPlaying{
            return
        }
        else{
            self.isActionPlaying = true
        }
        tankAnchor!.notifications.turretRight.post()
    }
    
    @IBAction func cannonFilePressed(_ sender: Any) {
        if self.isActionPlaying{
            return
        }
        else{
            self.isActionPlaying = true
        }
        tankAnchor!.notifications.cannonFire.post()
    }
}
