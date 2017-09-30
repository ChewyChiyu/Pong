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
    
    var paddleA: SKSpriteNode!
    var paddleB: SKSpriteNode!
    
    var goalA: SKSpriteNode!
	var goalB: SKSpriteNode!

    var scoreALabel: SKLabelNode!
	var scoreBLabel: SKLabelNode!

    var ball: SKSpriteNode!
	
	var scoreA: Int = 0 {
		didSet {
			scoreALabel?.text = String(scoreA)
			ball.removeFromParent()
			ball.position = paddleB.position
			ball.position.y -= (ball.size.width * 2)
			addChild(ball)
			ball.physicsBody?.velocity = CGVector.zero
			ball.physicsBody?.applyImpulse(CGVector(dx : 200, dy : -600))
			if scoreA == 5 {
				reset(winner: paddleA)
			}
		}
	}
	
    var scoreB: Int = 0 {
        didSet {
            scoreBLabel?.text = String(scoreB)
            ball.removeFromParent()
            ball.position = paddleA.position
            ball.position.y += (ball.size.width * 2)
            addChild(ball)
            ball.physicsBody?.velocity = CGVector.zero
            ball.physicsBody?.applyImpulse(CGVector(dx : 200, dy : 600))
            
            if scoreB == 5 {
                reset(winner: paddleB)
            }
        }
    }

    var gameStart: Bool = false
	
    override func didMove(to view: SKView) {
		paddleA = self.childNode(withName: "PaddleT") as? SKSpriteNode
		paddleB = self.childNode(withName: "PaddleB") as? SKSpriteNode
		goalB = self.childNode(withName: "GoalB") as? SKSpriteNode
		goalA = self.childNode(withName: "GoalT") as? SKSpriteNode
		scoreBLabel = self.childNode(withName: "ScoreB") as? SKLabelNode
		scoreALabel = self.childNode(withName: "scoreA") as? SKLabelNode
		
		ball = self.childNode(withName: "Ball") as? SKSpriteNode
		
        let ballBorder = SKPhysicsBody(edgeLoopFrom: self.frame)
        ballBorder.friction = 0
        ballBorder.restitution = 1
        ballBorder.angularDamping = 1
        ballBorder.linearDamping = 1
        physicsBody = ballBorder
		
        physicsWorld.contactDelegate = self
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let pointA = contact.bodyA
        let pointB = contact.bodyB
		
        if pointB.node?.name == "Ball" {
            if pointA.node?.name == "GoalB" {
                scoreA += 1
            } else if pointA.node?.name == "GoalT" {
                scoreB += 1
            }
        }
        if pointA.node?.name == "Ball" {
            if pointB.node?.name == "GoalB" {
                scoreA += 1
            } else if pointB.node?.name == "GoalT" {
                scoreB += 1
            }
        }
    }
	
    func reset(winner: SKSpriteNode){
        if let scene = SKScene(fileNamed: "Pong") {
            let skView = self.view! as SKView
            skView.ignoresSiblingOrder = true
            scene.scaleMode = .aspectFill
            scene.size = skView.bounds.size
            skView.presentScene(scene, transition: SKTransition.fade(withDuration: 1))
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStart {
            gameStart = true
            ball.physicsBody?.applyImpulse(CGVector(dx : 200, dy : 600))
        }
    }
	
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in: self)
            if location.y > 0 {
                if location.x + paddleB.size.width / 2 < (view?.bounds.width)! / 2 && location.x - paddleB.size.width / 2 > -(view?.bounds.width)! / 2 {
                  //  paddleB.position.x = location.x
                    paddleB.run(SKAction.move(to: CGPoint(x: location.x, y : paddleB.position.y), duration: 0.00000001))
                }
            } else {
                if location.x + paddleA.size.width / 2 < (view?.bounds.width)! / 2 && location.x - paddleA.size.width / 2 > -(view?.bounds.width)! / 2 {
                    //paddleT.position.x = location.x
                    paddleA.run(SKAction.move(to: CGPoint(x: location.x, y : paddleA.position.y), duration: 0.00000001))
                }
            }
		}
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
}
