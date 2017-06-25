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
    
    
    var spark = SKEmitterNode(fileNamed: "PongHit.sks")
    var goalSpark = SKEmitterNode(fileNamed: "PongGoal.sks")

    
    var scoreB: Int = 0{
        didSet{
            scoreBLabel?.text = String(scoreB)
            ball.removeFromParent()
            ball.position = paddleT.position
            ball.position.y += (ball.size.width * 2)
            addChild(ball)
            ball.physicsBody?.velocity = CGVector.zero
            ball.physicsBody?.applyImpulse(CGVector(dx : 200, dy : 600))
            
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
            ball.position.y -= (ball.size.width * 2)
            addChild(ball)
            ball.physicsBody?.velocity = CGVector.zero
            ball.physicsBody?.applyImpulse(CGVector(dx : 200, dy : -600))
            if(scoreT==5){
                reset(winner: paddleT)
            }
        }
    }
    
    
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
        
        
        goalSpark?.isHidden = true
        addChild(goalSpark!)
        
        spark?.isHidden = true
        addChild(spark!)
        
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let pointA = contact.bodyA
        let pointB = contact.bodyB
        
        
        if(pointB.node?.name == "Ball"){
            

            if(pointA.node?.name == "GoalB"){
                goalSpark?.isHidden = false
                goalSpark?.resetSimulation()
                goalSpark?.position = (pointB.node?.position)!
                scoreT+=1
            }
            else if(pointA.node?.name == "GoalT"){
                goalSpark?.isHidden = false
                goalSpark?.resetSimulation()
                goalSpark?.position = (pointB.node?.position)!
                scoreB+=1
            }else{
                spark?.isHidden = false
                spark?.resetSimulation()
                spark?.position = (pointB.node?.position)!
            }
           
        }
        if(pointA.node?.name == "Ball"){
            if(pointB.node?.name == "GoalB"){
                goalSpark?.isHidden = false
                goalSpark?.resetSimulation()
                goalSpark?.position = (pointA.node?.position)!
                scoreT+=1
            }
            else if(pointB.node?.name == "GoalT"){
                goalSpark?.isHidden = false
                goalSpark?.resetSimulation()
                goalSpark?.position = (pointA.node?.position)!
                scoreB+=1
            }else{
                spark?.isHidden = false
                spark?.resetSimulation()
                spark?.position = (pointA.node?.position)!
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
            ball.physicsBody?.applyImpulse(CGVector(dx : 200, dy : 600))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if( location.y > 0){
                if(location.x + paddleB.size.width/2 < (view?.bounds.width)!/2 && location.x - paddleB.size.width/2 > -(view?.bounds.width)!/2){
                  //  paddleB.position.x = location.x
                    paddleB.run(SKAction.move(to: CGPoint(x: location.x, y : paddleB.position.y), duration: 0.2))
                }
            }else{
                if(location.x + paddleT.size.width/2 < (view?.bounds.width)!/2 && location.x - paddleT.size.width/2 > -(view?.bounds.width)!/2){
                    //paddleT.position.x = location.x
                    paddleT.run(SKAction.move(to: CGPoint(x: location.x, y : paddleT.position.y), duration: 0.2))
                }
                
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
