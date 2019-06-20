//
//  GameScene.swift
//  Flappy Bird
//
//  Created by 00457054 on 20/06/19.
//  Copyright © 2019  All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode() //animate hoga
    var bg = SKSpriteNode()
    var scoreLabel = SKLabelNode()
     var scoreOver = SKLabelNode()
    var score = 0
    var timer = Timer()
    // creating an enum too separate bird and other objects
    enum ColliderTypes: UInt32 {
        // = 後方即為raw-value
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    var gameOver = false
    
    @objc func makePipes(){
        //making pipes and bird separate,此處設定pipe & gap
        let gapHeight = bird.size.height * 4
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffSet = CGFloat(movementAmount) - self.frame.height / 4
        // animating pipes
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100)) //in accordance with different screen size(不用定值)不用定值，TimeInterval : 時間間隔
        
        //Pipes
        
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height/2 + gapHeight/2 + pipeOffSet)
        pipe1.run(movePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())//physicsBody為矩形，大小是pipeTexture的大小
        pipe1.physicsBody!.isDynamic = false
        
        
        pipe1.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue //with whose contact
        pipe1.physicsBody!.categoryBitMask = ColliderTypes.Object.rawValue //which category
        pipe1.physicsBody!.collisionBitMask = ColliderTypes.Object.rawValue //跟什麼碰撞
        pipe1.zPosition = -1 //將z_position設為－１，這樣SpriteKit將在任何默認z_Position为0的node之前繪製背景.
        self.addChild(pipe1) // 將pipe１加入scene中
        
        let pipe2 = SKSpriteNode(texture: pipe2Texture) //pipe2與pipe1方法雷同
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture.size().height/2 - gapHeight/2 + pipeOffSet)
        pipe2.run(movePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue //with whose contact
        pipe2.physicsBody!.categoryBitMask = ColliderTypes.Object.rawValue //which category
        pipe2.physicsBody!.collisionBitMask = ColliderTypes.Object.rawValue// 對照上方的enum
        pipe2.zPosition = -1
        self.addChild(pipe2)
        
        // calculating scores
        
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffSet)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
        gap.physicsBody!.isDynamic = false
        gap.run(movePipes)  //same animation as pipes
        
        gap.physicsBody!.contactTestBitMask = ColliderTypes.Bird.rawValue //with whose contact
        gap.physicsBody!.categoryBitMask = ColliderTypes.Gap.rawValue //which category
        gap.physicsBody!.collisionBitMask = ColliderTypes.Gap.rawValue
        
        self.addChild(gap)
    }
    
    //didBegin : https://developer.apple.com/documentation/spritekit/skphysicscontactdelegate/1449595-didbegin in SKPhysicsContactDelegate
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
        //判斷contact 的物件
        if contact.bodyA.categoryBitMask == ColliderTypes.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderTypes.Gap.rawValue { //碰到的是gap時
            
            print("+1 to score")
           score += 1 //過一個得一分
            scoreLabel.text = String(score) //update scoreLabel 內容
        
        }
        else{
            print("We have contact")
            self.speed = 0
            gameOver = true
            
            // scoreOver attribute
            scoreOver.fontName = "Helvetica"
            scoreOver.fontSize = 30
            scoreOver.text = "Game Over, Tap To Play Again"
            scoreOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            self.addChild(scoreOver) //將scoreOver顯示於畫面上
            timer.invalidate() // Stops the timer from ever firing again and requests its removal from its run loop.
        }
     }
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self //Methods your app can implement to respond when physics bodies come into contact.
        
        setupGame()
       
    }
    
    func setupGame() { //建立game
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true) //timeInterval :每隔３s執行一次  target : 對象為自己（通常是）對象為自己（通常是）selector : 對像為自己類別的makePipes() repeat : 重複執行 所以若timeInterval若是設太小，柱子間距會太近，遊戲難玩
        
        
        //Background
        let bgTexture = SKTexture(imageNamed: "bg.png")
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 7)//duration : 持續
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i : CGFloat = 0 //預設為０（CGFloat)
        
        
        while i < 3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.run(moveBGForever) //背景move
            bg.zPosition = -2 // 不加柱子會被隱藏
            self.addChild(bg)
            i += 1
            
        }
 
        //bird Attributes
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.run(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        bird.physicsBody!.isDynamic = false
        bird.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue //with whose contact
        bird.physicsBody!.categoryBitMask = ColliderTypes.Bird.rawValue //which category
        bird.physicsBody!.collisionBitMask = ColliderTypes.Bird.rawValue
        
        self.addChild(bird)
        
        //Invisible ground 去掉不影響去掉不影響
        
        let ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue //with whose contact
        ground.physicsBody!.categoryBitMask = ColliderTypes.Object.rawValue //which category
        ground.physicsBody!.collisionBitMask = ColliderTypes.Object.rawValue
        self.addChild(ground)
 
        
        //scoreLabel attribute
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0 )
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height/2 - 200)
        self.addChild(scoreLabel)
    }
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {//點擊事件，用觸碰就可以操控
      
        if gameOver == false {
        bird.physicsBody!.isDynamic = true // bird 會跟著被移動
        bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)//bird速度不變（可模擬加減速的物理量）
        bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50)) //making tuffer by increasing the value，模擬受到的重力量（bird會往下掉)
        }
        else {
            gameOver = false //從來一次
            score = 0 //成績歸零
            self.speed = 1 //一般飛行速度，之後可加判斷成績超過多少加速
            self.removeAllChildren()
            setupGame()//重新建立一次遊戲
        }
       
    }
    
   
    
    override func update(_ currentTime: TimeInterval) { 
        // Called before each frame is rendered(呈現)
    }
}
