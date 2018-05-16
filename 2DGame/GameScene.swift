//
//  GameScene.swift
//  2DGame
//
//  Created by Ylst, Zachary on 5/14/18.
//  Copyright © 2018 CTEC. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
    var player = SKSpriteNode()
    var platform = SKSpriteNode()
    var circlePlatform1 = SKSpriteNode()
    var circlePlatform2 = SKSpriteNode()
    var winLabel = SKLabelNode()
    
    var goalZone = SKRegion(path: CGPath(rect: CGRect(x: -325, y: 1212.5, width: 250, height: 65), transform: nil))
    
    var cameraNode = SKCameraNode()
    
    var direction: Int = 1
    var grounded: Bool = true
    
    override func didMove(to view: SKView)
    {
        player = self.childNode(withName: "player") as! SKSpriteNode
        player.physicsBody?.usesPreciseCollisionDetection = true
        platform = self.childNode(withName: "platform") as! SKSpriteNode
        circlePlatform1 = self.childNode(withName: "circlePlatform1") as! SKSpriteNode
        circlePlatform2 = self.childNode(withName: "circlePlatform2") as! SKSpriteNode
        winLabel = self.childNode(withName: "winLabel") as! SKLabelNode
        winLabel.isHidden = true
        
        cameraNode = self.childNode(withName: "cameraNode") as! SKCameraNode
        
        physicsWorld.contactDelegate = self
        
        createCirclePath()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let touchLocation = touch.location(in: self)
            if (touchLocation.x < cameraNode.position.x)
            {
                direction = -1
                player.physicsBody?.velocity = CGVector(dx: -250, dy: (player.physicsBody?.velocity.dy)!)
            }
            else if (touchLocation.x > cameraNode.position.x)
            {
                direction = 1
                player.physicsBody?.velocity = CGVector(dx: 250, dy: (player.physicsBody?.velocity.dy)!)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        for touch in touches
        {
            let touchLocation = touch.location(in: self)
            if (touchLocation.x < cameraNode.position.x)
            {
                direction = -1
                player.physicsBody?.velocity = CGVector(dx: -250, dy: (player.physicsBody?.velocity.dy)!)
            }
            else if (touchLocation.x > cameraNode.position.x)
            {
                direction = 1
                player.physicsBody?.velocity = CGVector(dx: 250, dy: (player.physicsBody?.velocity.dy)!)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        player.physicsBody?.velocity.dx = 0.0
    }
    
    func didBegin(_ contact: SKPhysicsContact)
    {
        grounded = true
    }
    
    func didEnd(_ contact: SKPhysicsContact)
    {
        grounded = false
        jump(player)
    }
    
    override func update(_ currentTime: TimeInterval)
    {
        cameraNode.position = CGPoint(x: player.position.x, y: player.position.y)
        
        if (goalZone.contains(player.position))
        {
            winLabel.position = cameraNode.position
            winLabel.isHidden = false
        }
    }
    
    func createCirclePath()
    {
        let circlePath1 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: -400, y: -200), size: CGSize(width: 800, height: 400)))
        let circlePath1Follow = SKAction.follow(circlePath1.cgPath, asOffset: false, orientToPath: false, duration: 5.0)
        circlePlatform1.run(SKAction.repeatForever(circlePath1Follow))
        let circlePath2 = UIBezierPath(ovalIn: CGRect(origin: CGPoint(x: -200, y: 600), size: CGSize(width: 800, height: 400)))
        let circlePath2Follow = SKAction.follow(circlePath2.cgPath, asOffset: false, orientToPath: false, duration: 5.0)
        circlePlatform2.run(SKAction.repeatForever(circlePath2Follow))
    }
    
    func jump(_ node: SKSpriteNode)
    {
        if (!grounded)
        {
            node.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 165))
        
            if (direction == -1)
            {
                let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.75)
                node.run(rotate)
            }
            else if (direction == 1)
            {
                let rotate = SKAction.rotate(byAngle: CGFloat(-(Double.pi)), duration: 0.75)
                node.run(rotate)
            }
        }
    }
}
