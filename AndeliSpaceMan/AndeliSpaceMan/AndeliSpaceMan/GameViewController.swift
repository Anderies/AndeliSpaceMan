//
//  GameViewController.swift
//  AndeliSpaceMan
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Real. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    //it’s an optional. You know it’s an optional because an exclamation point (!) follows its declaration
    var scene : GameScene!
    
    //after scene declaration i dont want status bar displayed in game
    override var prefersStatusBarHidden: Bool{
        return true
    }

    override func viewDidLoad() {
        //this method below is to configure my main view
        super.viewDidLoad()
        //1.Configure the main view
        //skView will be host of my game scene its act like UIView but it has his unique property
        let skView = view as! SKView
        //thus is used to show frames per second that application is rendering
        skView.showsFPS = true
        
        //2.Create and configure our game scene
        //initialize the size to match the size of the view that will host the scene
        scene = GameScene(size: skView.bounds.size)
        //scaleMode is used to determine how the scene will be scaled to match the view that will contain it
        scene.scaleMode = .aspectFill
        
        //3.Show the scene
        skView.presentScene(scene)
        }
    }

