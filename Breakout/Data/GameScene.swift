

import UIKit
import SpriteKit
import CoreMotion

let BallCategory   : UInt32 = 0x1 << 0
let BottomCategory : UInt32 = 0x1 << 1
let BlockCategory  : UInt32 = 0x1 << 2
let PaddleCategory : UInt32 = 0x1 << 3
let BorderCategory : UInt32 = 0x1 << 4

class GameScene: SKScene, SKPhysicsContactDelegate{
    var dt: TimeInterval = 0
    var lastUpdateTime: TimeInterval = 0
    var velocity = CGPoint.zero
    var motionManager: CMMotionManager!
    var destX : CGFloat = 0.0
    var destY : CGFloat = 0.0
    let robot = SKSpriteNode(imageNamed: "Run (1)")
    let robotMovePointPerSec: CGFloat = 100
    var phoneSize = GameViewController.screensize
    var red1 = 54.0
    var green1 = 78.0
    var blue1 = 104.0
    var ballInPlay = false
    var start: CGPoint?
    var end: CGPoint?
    let launchLabel = SKLabelNode(text: "Launch")
    var blockCounter = 0
    
    var isFingerOnPaddle = false
    let paddleRect = SKShapeNode(rectOf: CGSize(width: 160, height: 20))
    let brickSound = SKAction.playSoundFileNamed("pongBlip.wav", waitForCompletion: false)
    let paddleSound = SKAction.playSoundFileNamed("paddleBlip.wav", waitForCompletion: false)
    let looseSound = SKAction.playSoundFileNamed("bottomHit.wav", waitForCompletion: false)
    
    let livesLabel = SKLabelNode(text: "Lives:")
    var lives: Int = 3{
        didSet{
            livesLabel.text = "Lives: \(Int(lives))"
            livesLabel.fontName = "Futura-MediumItalic"
            livesLabel.fontSize = 24
        }
    }
    let timerLabel = SKLabelNode(text: "Timer:")
    var remainingTime: TimeInterval = 60{
        didSet{
            timerLabel.text = "Timer: \(Int(remainingTime))"
            timerLabel.fontName = "Futura-MediumItalic"
            timerLabel.fontSize = 24
        }
    }
    let scoreLabel = SKLabelNode(text: "Score:")
    var currentScore: Int = 0{
        didSet{
            scoreLabel.text = "Score: \(currentScore)"
            scoreLabel.fontName = "Futura-MediumItalic"
            scoreLabel.fontSize = 24
            GameManager.sharedInstance.score = currentScore
        }
    }
    
    
    
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        setupLabels()
        setupPhysics()
        setUpBricks()
        setBGColor()
        remainingTime = 60
        gameTimer()
        launchBall()
        
        print(phoneSize)
        
        motionManager = CMMotionManager()
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.01
            motionManager.startAccelerometerUpdates(to: OperationQueue.main) {
                (data, error) in
                let currrentX = self.paddleRect.frame.origin.x
                self.destX = currrentX + CGFloat((data?.acceleration.x)! * 50)
                if self.destX < self.view!.bounds.width - 80 && self.destX > 0 {
                    self.paddleRect.position.x = self.destX
                }
                
                //                let currrentY = self.paddleRect.frame.origin.y
                //                self.destY = currrentY + CGFloat((data?.acceleration.y)! * -50)
                //                if self.destY < (self.view?.bounds.height)! - 40 &&  self.destY > 0 {
                //                    self.paddleRect.position.y = self.destY
                //                }
                
            }
        }
        
        
        
        robot.position = CGPoint(x: size.width - (size.width * 0.85), y: size.height - (size.height * 0.05) )
        robot.size = CGSize(width: 50, height: 50)
        
        var textures: [SKTexture] = []
        for i in 1...7 {
            textures.append(SKTexture(imageNamed: "Run (\(i))"))
        }
        let robotRun: SKAction
        robotRun = SKAction.animate(with: textures, timePerFrame: 0.1)
        robot.run(SKAction.repeatForever(robotRun))
        addChild(robot)
        
    }
    
    func moveSprite(_ sprite: SKSpriteNode, velocity: CGPoint){
        let amountToMove = CGPoint(x: velocity.x * CGFloat(dt), y: velocity.y * CGFloat(dt))
        sprite.position = CGPoint(x: sprite.position.x + amountToMove.x, y: sprite.position.y + amountToMove.y)
    }
    
    func launchBall(){
        launchLabel.fontName = "Futura-MediumItalic"
        launchLabel.fontSize = 55
        launchLabel.fontColor = .white
        launchLabel.position = CGPoint(x: size.width / 2, y: size.height  * 0.35)
        addChild(launchLabel)
        
    }
    
    func setBGColor(){
        
        let bgColor1 = UIColor(displayP3Red: CGFloat(red1 / 255.0), green: CGFloat(green1 / 255.0), blue: CGFloat(blue1 / 255.0), alpha: 1)
        backgroundColor = UIColor.black
        
    }
    
    
    
    func setUpBricks(){
        
        let level1 =   """
                        -_o-o_-,
                        o-_o_-o,
                        -_o-o_-
                        """
        let level2 =   """
                        -ooooooo-,
                        -_-----_-,
                        _oo_o_oo_,
                        __-----__
                        """
        
        if(lives < 4){
            
            let blockWidth = SKSpriteNode(imageNamed: "yellowBlock.png").size.width
            let blockHeight = SKSpriteNode(imageNamed: "yellowBlock.png").size.height
            let xOffset = (frame.width - (blockWidth * 8)) / 2
            let yOffset = frame.height * 0.95
            var index = 1
            var block = SKSpriteNode(imageNamed: "yellowBlock.png")
            setUpBricksPhysics()
            var i = 0
            
            
            for char in level2{
                
                switch (char) {
                case "o":
                    
                    block = SKSpriteNode(imageNamed: "yellowBlock.png")
                    block.position = CGPoint(x: xOffset + (CGFloat(i) * blockWidth),
                                             y: (yOffset - (blockHeight * CGFloat(index))))
                    block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                    block.physicsBody!.categoryBitMask = BlockCategory
                    block.physicsBody?.isDynamic = false
                    block.zPosition = 2
                    blockCounter += 1
                    
                    self.addChild(block)
                    
                    i += 1
                    break
                    
                case "-":
                    block = SKSpriteNode(imageNamed: "orangeBlock.png")
                    block.position = CGPoint(x: xOffset + (CGFloat(i) * blockWidth),
                                             y: (yOffset - (blockHeight * CGFloat(index))))
                    block.physicsBody = SKPhysicsBody(rectangleOf: block.size)
                    block.physicsBody!.categoryBitMask = BlockCategory
                    block.physicsBody?.isDynamic = false
                    block.zPosition = 2
                    self.addChild(block)
                    blockCounter += 1
                    i += 1
                    break
                    
                case ",":
                    i = 0
                    index += 1
                    break
                    
                case "_":
                    let emptyBlock = SKShapeNode(rectOf: CGSize(width: block.size.width, height: block.size.height))
                    emptyBlock.position = CGPoint(x: xOffset + (CGFloat(i) * blockWidth),
                                                  y: (yOffset - (blockHeight * CGFloat(index))))
                    emptyBlock.lineWidth = 0
                    self.addChild(emptyBlock)
                    i += 1
                    break
                    
                default:
                    break
                }
                //                    }]))
            }
        }
        print("blockcounter: \(blockCounter)")
        //        }
    }
    
    func setupLabels(){
        
        if(phoneSize.width >= 800){
            livesLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.25) )
            livesLabel.text = "Lives: \(Int(lives))"
            livesLabel.fontName = "Futura-MediumItalic"
            livesLabel.fontSize = 24
            addChild(livesLabel)
            timerLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.15))
            GameManager.sharedInstance.score = currentScore
            timerLabel.fontName = "Futura-MediumItalic"
            timerLabel.fontSize = 24
            addChild(timerLabel)
            scoreLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.2) )
            scoreLabel.text = "Score: \(currentScore)"
            scoreLabel.fontName = "Futura-MediumItalic"
            scoreLabel.fontSize = 24
            addChild(scoreLabel)
        }else{
            livesLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.15) )
            livesLabel.text = "Lives: \(Int(lives))"
            livesLabel.fontName = "Futura-MediumItalic"
            livesLabel.fontSize = 24
            addChild(livesLabel)
            timerLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.05))
            GameManager.sharedInstance.score = currentScore
            timerLabel.fontName = "Futura-MediumItalic"
            timerLabel.fontSize = 24
            addChild(timerLabel)
            scoreLabel.position = CGPoint(x: size.width - (size.width * 0.95), y: size.height - (size.height * 0.1) )
            scoreLabel.text = "Score: \(currentScore)"
            scoreLabel.fontName = "Futura-MediumItalic"
            scoreLabel.fontSize = 24
            addChild(scoreLabel)
        }
        
    }
    
    
    func setUpBricksPhysics(){
        
        let block = SKSpriteNode(imageNamed: "yellowBlock.png")
        block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
        block.physicsBody!.allowsRotation = false
        block.physicsBody!.friction = 0.0
        //        block.physicsBody!.affectedByGravity = false
        block.physicsBody!.isDynamic = false
        block.name = "block"
        block.physicsBody!.categoryBitMask = BlockCategory
        block.zPosition = 2
    }
    
    func setUpBall(){
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(10))
        ball.physicsBody!.restitution = 1
        ball.physicsBody!.friction = 0.0
        ball.physicsBody!.affectedByGravity = true
        ball.physicsBody!.isDynamic = true
        ball.physicsBody!.angularDamping = 0
        ball.size = CGSize(width: 30, height: 30)
        ball.zPosition = 2
        ball.physicsBody?.linearDamping = 0
        ball.position = CGPoint(x: size.width / 2,
                                y: size.height * 0.15)
        ball.name = "ball"
        ball.physicsBody!.contactTestBitMask = BottomCategory | BlockCategory | BorderCategory | PaddleCategory
        ball.physicsBody!.categoryBitMask = BallCategory
        addChild(ball)
        ball.physicsBody!.applyImpulse(CGVector(dx: 5.0, dy: 10.0))
        
        let trailNode = SKNode()
        trailNode.zPosition = 2
        addChild(trailNode)
        
        let trail = SKEmitterNode(fileNamed: "BallTrail")!
        trail.targetNode = trailNode
        ball.addChild(trail)
        
    }
    
    func setupPhysics(){
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        borderBody.friction = 0
        borderBody.restitution = 1
        self.physicsBody = borderBody
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        physicsWorld.contactDelegate = self
        
        let block = SKSpriteNode(imageNamed: "yellowBlock.png")
        block.physicsBody = SKPhysicsBody(rectangleOf: block.frame.size)
        block.physicsBody!.allowsRotation = false
        block.physicsBody!.friction = 0.0
        block.physicsBody!.affectedByGravity = false
        block.physicsBody!.isDynamic = false
        block.name = "block"
        block.physicsBody!.categoryBitMask = BlockCategory
        block.zPosition = 2
        
        paddleRect.position = CGPoint(x: frame.width / 2, y: frame.height * 0.1 )
        paddleRect.lineWidth = 2
        paddleRect.strokeColor = .red
        paddleRect.fillColor = .blue
        paddleRect.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 160, height: 30))
        paddleRect.physicsBody?.isDynamic = false
        addChild(paddleRect)
        
        let bottomRect = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: 10)
        let bottom = SKNode()
        bottom.physicsBody = SKPhysicsBody(edgeLoopFrom: bottomRect)
        addChild(bottom)
        
        borderBody.categoryBitMask = BorderCategory
        bottom.physicsBody!.categoryBitMask = BottomCategory
        paddleRect.physicsBody!.categoryBitMask = PaddleCategory
        
    }
    
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BottomCategory {
            
            self.run(looseSound)
            print("loose one life")
            looseOneLife()
            
        }
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BlockCategory {
            breakBlock(node: secondBody.node!)
            currentScore += 1
            self.run(brickSound)
        }
        
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == BorderCategory {
            //            print("hit border")
            
        }
        
        
        if firstBody.categoryBitMask == BallCategory && secondBody.categoryBitMask == PaddleCategory {
            print("hit paddle")
            self.run(paddleSound)
        }
    }
    
    
    func breakBlock(node: SKNode) {
        let scale = SKAction.scale(by: 0.8, duration: 0.1)
        let reverseScale = scale.reversed()
        let actions = [scale, reverseScale]
        let sequence = SKAction.sequence(actions)
        scoreLabel.run(sequence)
        let particles = SKEmitterNode(fileNamed: "BrokenPlatform")!
        particles.position = node.position
        particles.zPosition = 3
        addChild(particles)
        particles.run(SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                         SKAction.removeFromParent()]))
        node.removeFromParent()
    }
    
    func runAnimation(){
        let scale = SKAction.scale(by: 0.8, duration: 0.1)
        let reverseScale = scale.reversed()
        let actions = [scale, reverseScale]
        let sequence = SKAction.sequence(actions)
        livesLabel.run(sequence)
    }
    
    
    func looseOneLife(){
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(10))
        let node = childNode(withName: "ball")
        node?.removeFromParent()
        lives -= 1
        print(lives)
        runAnimation()
        ballInPlay = false
        
        launchLabel.run(SKAction.unhide())
        if(lives > 0){
            isGameWon()
        }else if (lives < 1){
            gameOver()
            
        }
        
    }
    
    func isGameWon(){
        
        if(blockCounter < 1){
            print("blockcounter: \(blockCounter)")
            //            nextLevel()
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let ball = SKSpriteNode(imageNamed: "ball")
            ball.physicsBody = SKPhysicsBody(circleOfRadius: CGFloat(10))
            let location = touch.location(in: self)
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            paddleRect.run(SKAction.moveTo(x: location.x, duration: 0.2))
            
            if node == launchLabel {
                setUpBall()
                ballInPlay = true
                node.run(SKAction.hide())
            }
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches{
            let location = touch.location(in: self)
            let paddleRect = SKSpriteNode(imageNamed: "blue" )
            paddleRect.run(SKAction.moveTo(x: location.x, duration: 0.2))
            
        }
        
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        
    }
    
    func gameOver(){
        GameManager.sharedInstance.saveGameStats()
        let scene = GameScene(size: CGSize(width: 1334, height: 750))
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1)
        self.view?.presentScene(scene, transition: transition)
    }
    
    func gameTimer(){
        
        let timeAction = SKAction.repeatForever(SKAction.sequence([SKAction.run ({
            self.remainingTime -= 1
        }), SKAction.wait(forDuration: 1)]))
        timerLabel.run(timeAction)
        print(remainingTime)
    }
    
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        if lastUpdateTime > 0 {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        print("\(dt * 1000) millisecnds")
        
        moveSprite(robot, velocity: CGPoint(x: robotMovePointPerSec , y: 0))
        
        if(ballInPlay){
            let ball = childNode(withName: "ball") as! SKSpriteNode
            let maxSpeed: CGFloat = 1300.0
            let xSpeed = sqrt(ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx)
            let ySpeed = sqrt(ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy)
            
            let speed = sqrt((ball.physicsBody!.velocity.dx * ball.physicsBody!.velocity.dx) + (ball.physicsBody!.velocity.dy * ball.physicsBody!.velocity.dy))
            
            if xSpeed <= 20.0 {
                ball.physicsBody!.applyImpulse(CGVector(dx: Double(Float.random(in: 0 ..< 10)), dy: 0.0))
                //            print("x: " ,xSpeed)
            }
            if ySpeed <= 10.0 {
                ball.physicsBody!.applyImpulse(CGVector(dx: 0.0, dy: Double(Float.random(in: 0 ..< 10))))
                //            print("y: ", ySpeed)
            }
            
            if speed > maxSpeed {
                ball.physicsBody!.linearDamping = 0.4
                print("speed: ", speed)
            } else {
                ball.physicsBody!.linearDamping = 0.0
            }
            //        print("xSpeed: \(xSpeed) ySpeed: \(ySpeed)")
        }
    }
}



