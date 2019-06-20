//
//  GameViewController.swift
//  Flappy Bird
//
//  Created by 00457054 on 20/06/19.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present(呈現) the scene
                view.presentScene(scene)
            }
            
            //SKView屬性設定 ： https://www.jianshu.com/p/c50f4db0b1b9
            view.ignoresSiblingOrder = true // 是否利用Z轴的層級深浅关系層級深淺来定制及定製繪製次序
            
            view.showsFPS = true // 是否显示游戏的FPS
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {//螢幕會自動轉向
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
