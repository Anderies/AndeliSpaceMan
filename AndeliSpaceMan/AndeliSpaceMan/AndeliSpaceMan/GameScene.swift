//
//  GameScene.swift
//  AndeliSpaceMan
//
//  Created by apple on 2018/10/16.
//  Copyright © 2018 Real. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion // to access accelometer library

class GameScene: SKScene {
    //both of this var has being intialized by the images in the image.xcassets folder
    //SKSpriteNode is the descendent of an SKNode(it doesnt draw any visual elements)
    let backgroundNode = SKSpriteNode(imageNamed:"Background")
    
    //this node will hold all the sprites that will affect game play
    let foregroundNode = SKSpriteNode()
    
    let playerNode = SKSpriteNode(imageNamed:"Player")
    
    var impulseCount = 4
    
    let CollisionCategoryPlayer  : UInt32 = 0x1 << 1 // variable used to be notified player
    let CollisionCategoryPowerUpOrbs : UInt32 = 0x1 << 2 // variable used to be notified orb
    //This property will hold an instance to the CMMotionManager object that will be used to monitor horizontal movement
    let coreMotionManager = CMMotionManager()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize){
        super.init(size: size)
        physicsWorld.contactDelegate = self //to make the GameScene the delegate of the scene’s physicsWorld.contactDelegate
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -5.0)
        
        
        
        //this line code of below sets the width of the backgroundNode to the width of the views frame
        backgroundNode.size.width = frame.size.width
        //The next line of code determines where the new node will be anchored in your scene
        //and this located on background bottom center of the node
        backgroundNode.anchorPoint = CGPoint(x: 0.5,y: 0.0)
        backgroundNode.position = CGPoint(x: size.width/2.0,y:0.0)
        //add background node to my scene
        addChild(backgroundNode)
        //add foreground node to my scene
        addChild(foregroundNode)
        
        
        
        // create skphysics body initializer parameter circle of radius with cg float
        playerNode.physicsBody = SKPhysicsBody(circleOfRadius: playerNode.size.width / 2)
        // turn player node into a physics body with a dynamic volume
        playerNode.physicsBody?.isDynamic = false
        playerNode.position = CGPoint(x: size.width / 2.0, y: 180.0)
        playerNode.physicsBody?.linearDamping = 1.0
        //prevent player node spinning off cause of collision with static orb
        playerNode.physicsBody?.allowsRotation = false
        //associates the playerNode.physicsBody’s category bit mask to the CollisionCategoryPlayer.
        playerNode.physicsBody?.categoryBitMask = CollisionCategoryPlayer
        //tells SpriteKit that whenever your physics
        //body comes into contact with another physics body belonging to categirt you want to be notified
        playerNode.physicsBody?.contactTestBitMask = CollisionCategoryPowerUpOrbs
        //tells SpriteKit not to handle collisions for you
        playerNode.physicsBody?.collisionBitMask = 0
        //add player node to scene
        foregroundNode.addChild(playerNode)
        
        var orbNodePosition = CGPoint(x: playerNode.position.x, y: playerNode.position.y + 100)
        for _ in 0...19 { //20 orb
            //will be centered and will start 100 points above the playNode, with 140 points in between each node’s anchorPoint.
            let orbNode = SKSpriteNode(imageNamed: "PowerUp")
            orbNodePosition.y += 140
            orbNode.position = orbNodePosition
            //orb radius
            orbNode.physicsBody = SKPhysicsBody(circleOfRadius: orbNode.size.width / 2)
            orbNode.physicsBody?.isDynamic = false
            
            //notified
            orbNode.physicsBody?.categoryBitMask = CollisionCategoryPowerUpOrbs
            orbNode.physicsBody?.collisionBitMask = 0
            //orb name
            orbNode.name = "POWER_UP_ORB"
            foregroundNode.addChild(orbNode)
        }
        
       
        
    }
    
    //touch responder to apply impulse every time i tap screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !playerNode.physicsBody!.isDynamic {
            playerNode.physicsBody?.isDynamic = true
            
            coreMotionManager.accelerometerUpdateInterval = 0.3 // nterval, in seconds, that the accelerometer will use to update the app with the current acceleration  3/10ths of a second
        
            coreMotionManager.startAccelerometerUpdates() //starts the accelerometer updates
        }
        if impulseCount > 0 {
            playerNode.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: 40.0))
            impulseCount -= 1
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) { //
        if playerNode.position.y >= 180.0 {
            backgroundNode.position =
                CGPoint(x: backgroundNode.position.x,
                        y: -((playerNode.position.y - 180.0)/8))
            foregroundNode.position =
                CGPoint(x: foregroundNode.position.x,
                        y: -(playerNode.position.y - 180.0))
        }
    }
    
    
    override func didSimulatePhysics() {
        if let accelerometerData = coreMotionManager.accelerometerData {
            playerNode.physicsBody!.velocity =
                CGVector(dx: CGFloat(accelerometerData.acceleration.x * 380.0),
                         dy: playerNode.physicsBody!.velocity.dy)
        }
        if playerNode.position.x < -(playerNode.size.width / 2) {
            playerNode.position =
                CGPoint(x: size.width - playerNode.size.width / 2,
                        y: playerNode.position.y);
        }
            else if playerNode.position.x > self.size.width {
            playerNode.position = CGPoint(x: playerNode.size.width / 2,
                                          y: playerNode.position.y);
        } }
}
extension GameScene: SKPhysicsContactDelegate { //for player contact with the orb node
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeB = contact.bodyB.node!
        if nodeB.name == "POWER_UP_ORB" {
            nodeB.removeFromParent() //when player touch orb . orb will disspear from parent or scene
        }
    }
}



