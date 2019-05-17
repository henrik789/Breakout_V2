////
////  GameFunctions.swift
////  Breakout
////
////  Created by Henrik on 2018-12-11.
////  Copyright © 2018 Henrik. All rights reserved.
////
//
//import SpriteKit
//import GameplayKit
//
//extension GameScene{
//
//func breakBlock(node: SKNode) {
//    let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
//    particles.position = node.position
//    particles.zPosition = 3
//    addChild(particles)
//    particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
//                                     SKAction.removeFromParent()]))
//    node.removeFromParent()
//}
//
//override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    let touch = touches.first
//    let touchLocation = touch!.location(in: self)
//    
//    if let body = physicsWorld.body(at: touchLocation) {
//        if body.node!.name == "paddle" {
//            print("Began touch on paddle")
//            isFingerOnPaddle = true
//        }
//    }
//}
//
//func didBegin(_ contact: SKPhysicsContact) {
//    
//    var firstBody: SKPhysicsBody
//    var secondBody: SKPhysicsBody
//    let ball = childNode(withName: "ball") as! SKSpriteNode
//    
//    
//    if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//        firstBody = contact.bodyA
//        secondBody = contact.bodyB
//    } else {
//        firstBody = contact.bodyB
//        secondBody = contact.bodyA
//    }
//    
//    if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
//        print("Hit bottom")
//        looseOneLife()
//        // loose one life, pause countdown until ball is released from paddle
//        
//    }
//    
//    if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
//        breakBlock(node: secondBody.node!)
//        currentScore += 1
//        //check if the game has been won
//    }
//    
//    // 1
//    if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BorderCategory {
//        
//    }
//    
//    
//    if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory {
//        
//    }
//}
//
//func looseOneLife(){
//    let ball = childNode(withName: "ball") as! SKSpriteNode
//    ball.physicsBody!.linearDamping = 1.0
//    physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
//    lives -= 1
//    let waitNode = SKAction.fadeOut(withDuration: 1)
//    ball.run(waitNode)
//    //        pause()
//    
//}
//
//
//func setUpBricks(){
//    
//    let uiKitWidth = phoneSize.width
//    let uiKitHeight = phoneSize.height
//    
//    
//    for i in 1...4{
//        //            print(width, height)
//        let rows = CGFloat(i)
//        
//        let numberOfBlocks = Int(11 - (rows * 2))
//        let blockWidth = SKSpriteNode(imageNamed: "yellowBlock.png").size.width
//        let blockHeight = SKSpriteNode(imageNamed: "yellowBlock.png").size.height
//        
//        print(blockHeight, blockWidth , uiKitWidth, uiKitHeight )
//        //            let blockWidth = SKSpriteNode(imageNamed: "redBlock").size.width
//        //            let blockHeight = SKSpriteNode(imageNamed: "redBlock").size.height
//        let totalBlocksWidth = blockWidth * CGFloat(numberOfBlocks)
//        let xOffset = (frame.width - totalBlocksWidth) / 2
//        var block = SKSpriteNode(imageNamed: "redBlock.png")
//        //            let rectBlock = SKShapeNode.init(rectOf: CGSize(width: blockWidth, height: blockHeight))
//        
//        
//        let rotateNode = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)
//        
//        //            print(blockHeight, blockWidth, xOffset, rows
//        
//        for i in 1..<numberOfBlocks {
//            
//            
//            if(rows == 1){
//                block = SKSpriteNode(imageNamed: "yellowBlock.png")
//                //                    block.run(waitNode)
//            }else if (rows == 2){
//                block = SKSpriteNode(imageNamed: "blueBlock.png")
//                
//                //                    addChild(rectBlock)
//            }else if (rows == 3){
//                block.run(rotateNode)
//                block = SKSpriteNode(imageNamed: "blue1Block.png")
//            }else if (rows == 4){
//                block = SKSpriteNode(imageNamed: "purpleBlock.png")
//            }else if (rows == 5){
//                block = SKSpriteNode(imageNamed: "orangeBlock")
//            }
//            
//            block.position = CGPoint(x: xOffset + CGFloat(i) * blockWidth,
//                                     y: (frame.height * 0.9) + (-(CGFloat(rows) * blockHeight)))
//            
//            block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
//            block.physicsBody!.allowsRotation = false
//            block.physicsBody!.friction = 0.0
//            block.physicsBody!.affectedByGravity = false
//            block.physicsBody!.isDynamic = false
//            block.name = "block"
//            block.physicsBody!.categoryBitMask = BlockCategory
//            block.zPosition = 2
//            addChild(block)
//        }
//    }
//    
//}
//
//
//func gameTimer(){
//    
//    let timeAction = SKAction.repeatForever(SKAction.sequence([SKAction.run ({
//        self.remainingTime -= 1
//    }), SKAction.wait(forDuration: 1)]))
//    timeLabel?.run(timeAction)
//    print(remainingTime)
//}
//
////
////override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
////    // 1
////    if isFingerOnPaddle {
////        // 2
////        let touch = touches.first
////        let touchLocation = touch!.location(in: self)
////        let previousLocation = touch!.previousLocation(in: self)
////        // 3
////        let paddle = childNode(withName: "paddle") as! SKSpriteNode
////        // 4
////        var paddleX = paddle.position.x + (touchLocation.x - previousLocation.x)
////        // 5
////        paddleX = max(paddleX, paddle.size.width/2)
////        paddleX = min(paddleX, size.width - paddle.size.width/2)
////        // 6
////        paddle.position = CGPoint(x: paddleX, y: paddle.position.y)
////    }
////}
////override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
////    isFingerOnPaddle = false
////}
////
////func randomFloat(from: CGFloat, to: CGFloat) -> CGFloat {
////    let rand: CGFloat = CGFloat(Float(arc4random()) / 0xFFFFFFFF)
////    return (rand) * (to - from) + from
////}
////
////func randomDirection() -> CGFloat {
////    let speedFactor: CGFloat = 3.0
////    if randomFloat(from: 0.0, to: 100.0) >= 50 {
////        return -speedFactor
////    } else {
////        return speedFactor
////    }
////}
//
////override func update(_ currentTime: TimeInterval) {
//    //        let ball = childNode(withName: "ball") as! SKSpriteNode
//    //        let maxSpeed: CGFloat = 900.0
//    //
//    //        let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
//    //        let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
//    //
//    //        let speed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx + ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
//    //
//    //        if xSpeed <= 10.0 {
//    //            ball.physicsBody!.applyImpulse(CGVector(dx: randomDirection(), dy: 0.0))
//    //            print("x: " ,xSpeed)
//    //        }
//    //        if ySpeed <= 10.0 {
//    //            ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: randomDirection()))
//    //            print("y: ", ySpeed)
//    //        }
//    //
//    //        if speed > maxSpeed {
//    //            ball.physicsBody!.linearDamping = 0.4
//    //            print("speed: ", speed)
//    //        } else {
//    //            ball.physicsBody!.linearDamping = 0.0
//    //        }
//    //
////}
//
//
//}
//
