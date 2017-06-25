//
//  Pong.swift
//  Pong
//
//  Created by Evan Chen on 6/23/17.
//  Copyright © 2017 Evan Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

class Pong: SKScene, SKPhysicsContactDelegate {
    
    var paddleT : SKSpriteNode!
    var paddleB : SKSpriteNode!
    
    var goalB : SKSpriteNode!
    var goalT : SKSpriteNode!
    
    var scoreBLabel : SKLabelNode!
    var scoreTLabel : SKLabelNode!
    
    var ball : SKSpriteNode!
    
    var scoreB: Int = 0{
        didSet{
            scoreBLabel?.text = String(scoreB)
            ball.removeFromParent()
            ball.position = paddleT.position
            ball.position.y += ball.size.width
            addChild(ball)
            ball.physicsBody?.velocity = CGVector.zero
            ball.physicsBody?.applyImpulse(CGVector(dx : 0, dy : -300))
            
            if(scoreB==5){
                reset(winner: paddleB)
            }
        }
    }
    
    var scoreT: Int = 0 {
        didSet{
            scoreTLabel?.text = String(scoreT)
            ball.removeFromParent()
            ball.position = paddleB.position
            ball.position.y -= ball.size.width
            addChild(ball)
            ball.physicsBody?.velocity = CGVector.zero
            ball.physicsBody?.applyImpulse(CGVector(dx : 0, dy : 300))
            if(scoreT==5){
                reset(winner: paddleT)
            }
        }
    }
    
    
    var tVelocityX :CGFloat = 0
    var bVelocityX: CGFloat = 0
    
    var maxXVelo: CGFloat = 200
    
    var gameStart:Bool = false
    
    override func didMove(to view: SKView) {
        
        paddleT = self.childNode(withName: "PaddleT") as? SKSpriteNode
        paddleB = self.childNode(withName: "PaddleB") as? SKSpriteNode
        goalB = self.childNode(withName: "GoalB") as? SKSpriteNode
        goalT = self.childNode(withName: "GoalT") as? SKSpriteNode
        scoreBLabel = self.childNode(withName: "ScoreB") as? SKLabelNode
        scoreTLabel = self.childNode(withName: "ScoreT") as? SKLabelNode
        
        ball = self.childNode(withName: "Ball") as? SKSpriteNode
        
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        borderBody.restitution = 1
        borderBody.angularDamping = 0
        borderBody.linearDamping = 0
        physicsBody = borderBody
        
        physicsWorld.contactDelegate = self
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let pointA = contact.bodyA
        let pointB = contact.bodyB
        
        
        if(pointB.node?.name == "Ball"){
            
            if(pointA.node?.name == "PaddleT"){
                pointB.node?.physicsBody?.velocity.dx  = (pointB.node?.physicsBody?.velocity.dx)! + tVelocityX
                
            }
            else if(pointA.node?.name == "PaddleB"){
                pointB.node?.physicsBody?.velocity.dx  = (pointB.node?.physicsBody?.velocity.dx)! + bVelocityX
                
            }
            else if(pointA.node?.name == "GoalB"){
                scoreT+=1
            }
            else if(pointA.node?.name == "GoalT"){
                scoreB+=1
            }
        }
        if(pointA.node?.name == "Ball"){
            if(pointB.node?.name == "PaddleT"){
                pointA.node?.physicsBody?.velocity.dx  = (pointA.node?.physicsBody?.velocity.dx)! + tVelocityX
                
            }
            else if(pointB.node?.name == "PaddleB"){
                pointA.node?.physicsBody?.velocity.dx  = (pointA.node?.physicsBody?.velocity.dx)! + bVelocityX
            }
            else if(pointB.node?.name == "GoalB"){
                scoreT+=1
            }
            else if(pointB.node?.name == "GoalT"){
                scoreB+=1
            }
            
        }
        
    }
    func reset(winner: SKSpriteNode){
        if let scene = SKScene(fileNamed:"Pong") {
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            scene.size = skView.bounds.size
            skView.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
        }

    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(!gameStart){
            gameStart = true
            ball.physicsBody?.applyImpulse(CGVector(dx : 0, dy : 300))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if( location.y > 0){
                if( location.x > paddleB.position.x){
                    bVelocityX = maxXVelo
                }
                if( location.x < paddleB.position.x){
                    bVelocityX = -maxXVelo
                }
                if(location.x + paddleB.size.width/2 < (view?.bounds.width)!/2 && location.x - paddleB.size.width/2 > -(view?.bounds.width)!/2){
                    paddleB.position.x = location.x
                }
            }else{
                if( location.x > paddleT.position.x){
                    tVelocityX = maxXVelo
                }
                if( location.x < paddleT.position.x){
                    tVelocityX = -maxXVelo
                }
                
                if(location.x + paddleT.size.width/2 < (view?.bounds.width)!/2 && location.x - paddleT.size.width/2 > -(view?.bounds.width)!/2){
                    paddleT.position.x = location.x
                }
                
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if( location.y > 0){
                bVelocityX = 0
            }else{
                tVelocityX = 0
            }
        }
        
    }
}
