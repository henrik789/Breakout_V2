//
//  GameManager.swift
//  Breakout
//
//  Created by Henrik on 2018-12-20.
//  Copyright © 2018 Henrik. All rights reserved.
//

import Foundation


class GameManager {
    var score:Int
    var highScore:Int
    
    class var sharedInstance: GameManager {
        struct Singleton {
            static let instance = GameManager()
        }
        
        return Singleton.instance
    }
    
    init() {
        score = 0
        highScore = 0
        
        let userDefaults = UserDefaults.standard
        highScore = userDefaults.integer(forKey: "highScore")
    }
    
    func saveGameStats() {
        highScore = max(score, highScore)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(highScore, forKey: "highScore")
        userDefaults.synchronize()
    }
    
}
