

import UIKit
import SpriteKit
//import GameplayKit

class GameViewController: UIViewController {

        public static let screensize = UIScreen.main.bounds
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let scene = StartScene(size: CGSize(width: 1334, height: 750))
        
                scene.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(scene)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
