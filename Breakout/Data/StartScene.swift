

import SpriteKit

class StartScene: SKScene{
   
    var scrollingBG: ScrollingBackground?
    var breakoutLogo = SKSpriteNode(imageNamed: "brick-wall2")
    let startLabel = SKLabelNode(text: "Start game")
    var highScoreLabel = SKLabelNode(text: "Highscore: ")
//    var highScore = GameManager.sharedInstance.highScore
    var gameScene:SKScene!
    var phoneSize = GameViewController.screensize
    
    override func didMove(to view: SKView) {

        scrollingBG = ScrollingBackground.scrollingNodeWithImage(imageName: "brick-wall", containerWidth: self.size.width)
        scrollingBG?.scrollingSpeed = 1.5
        scrollingBG?.anchorPoint = .zero
        self.addChild(scrollingBG!)
        
        setupLabels()

    }
    
    func setupLabels(){
        
        startLabel.fontName = "Futura-MediumItalic"
        startLabel.fontSize = 70
        startLabel.fontColor = UIColor.white
        startLabel.zPosition = 2
        startLabel.position = CGPoint(x: size.width - (size.width * 0.5), y: size.height - (size.height * 0.85) )
        let scale = SKAction.scale(by: 0.95, duration: 0.4)
        let reverseScale = scale.reversed()
        let actions = [scale, reverseScale]
        let sequence = SKAction.sequence(actions)
        let repeatSequence = SKAction.repeatForever(sequence)
        startLabel.run(repeatSequence)
        addChild(startLabel)
        
        breakoutLogo.size = CGSize(width: size.width * 1, height: size.height * 1)
        breakoutLogo.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        breakoutLogo.zPosition = 1
        addChild(breakoutLogo)
        
        highScoreLabel.position = CGPoint(x: size.width - (size.width * 0.5), y: size.height - (size.height * 0.65) )
        highScoreLabel.fontColor = .white
        highScoreLabel.zPosition = 2
        highScoreLabel.fontSize = 45
        highScoreLabel.text = "Highscore: \(GameManager.sharedInstance.highScore)"
        highScoreLabel.fontName = "Futura-MediumItalic"
        addChild(highScoreLabel)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if(phoneSize.width < 800){
            
                if node == startLabel {
                    let transition = SKTransition.fade(withDuration: 1)
                    let scene = GameScene(size: CGSize(width: 1334, height: 750))
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: transition)
                    
                }
                
            }else if(phoneSize.width > 800){
                
                if node == startLabel {
                    let transition = SKTransition.fade(withDuration: 1)
                    let scene = GameScene(size: CGSize(width: 1344, height: 621))
                    scene.scaleMode = .aspectFill
                    self.view?.presentScene(scene, transition: transition)
                    
                }
                
            }
            
        }
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        if let scrollBG = self.scrollingBG {
            scrollBG.update(currentTime: currentTime)
        }
    }
    
    
}
