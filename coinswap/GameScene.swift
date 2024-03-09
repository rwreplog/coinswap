//
//  GameScene.swift
//  coinswap
//
//  Created by Ryan Replogle on 11/29/20.
//

import SpriteKit
import AVFoundation

class Coin: SKSpriteNode { }

class GameScene: SKScene, SKPhysicsContactDelegate {
    var isGameOver = false
    var timer: Timer?
    var chestChange = 0
    var coins = ["blueCoin", "greenCoin", "redCoin", "yellowCoin"]
    let coin = SKSpriteNode()
    let greenChest = SKSpriteNode(imageNamed: "greenChest")
    let blueChest = SKSpriteNode(imageNamed: "blueChest")
    let redChest = SKSpriteNode(imageNamed: "redChest")
    let yellowChest = SKSpriteNode(imageNamed: "yellowChest")
    let scoreLabel = SKLabelNode(fontNamed: "Helvetica")
    let livesLabel = SKLabelNode(fontNamed: "Helvetica")
    let background = SKSpriteNode(imageNamed: "checkerboard")

    var score = 0 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedScore = formatter.string(from: score as NSNumber) ?? "0"
            scoreLabel.text = "SCORE: \(formattedScore)"
        }
    }
    
    var lives = 3 {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            let formattedLives = formatter.string(from: lives as NSNumber) ?? "3"
            livesLabel.text = "LIVES: \(formattedLives)"
        }
    }
    
    private var currentNode: SKNode?

    override func didMove(to view: SKView) {
        scheduledTimerWithTimeInterval(interval: 15)
        playSound(sound: "music1", type: "mp3")
        background.name = "bg"
        background.size = view.frame.size
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.alpha = 0.2
        background.zPosition = -10
//        background.physicsBody = SKPhysicsBody(rectangleOf: background.size)
//        background.physicsBody?.isDynamic = false
        addChild(background)
        
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self
        
        setupLabels()
        setupChests()
        
        let coin1 = SKSpriteNode(imageNamed: "blueCoin")
        let coinRadius = coin1.frame.width / 2.0

        let wait = SKAction.wait(forDuration: 1, withRange: 0.4)
        let spawn = SKAction.run {
        let ballType = self.coins.randomElement()!
        let coin = Coin(imageNamed: ballType)
            
        let height = UInt32(view.bounds.height)
        let width = UInt32(view.bounds.width)
            
        let cr2 = UInt32(coinRadius * 3)
        let finalWidth = UInt32(width - cr2)
        let finalHeight = UInt32(height - cr2)

            let randomPosition = CGPoint(x: Int(arc4random_uniform(finalWidth) + cr2), y: Int(arc4random_uniform(finalHeight) + cr2 ))

        coin.setScale(1.5)
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width / 2.0)
        coin.physicsBody?.restitution = 0.4
        coin.physicsBody?.affectedByGravity = false
        coin.physicsBody?.contactTestBitMask = coin.physicsBody?.collisionBitMask ?? 0
        coin.position = randomPosition
        coin.name = ballType
            
        self.addChild(coin)
            
        let scaleHeightAction = SKAction.sequence([SKAction.scale(to: 0.5, duration: 5.0), SKAction.wait(forDuration: 2.0),                                                SKAction.removeFromParent()])

        coin.run(scaleHeightAction, completion: { () -> Void in })
        }

        let sequence = SKAction.sequence([wait, spawn])
        self.run(SKAction.repeatForever(sequence))
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if isGameOver == true{
            let waitAction = SKAction.wait(forDuration: 5)
            run(waitAction, completion: { self.endGame() })
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes.reversed() {
                if node.name == "blueCoin" || node.name == "yellowCoin" || node.name == "greenCoin" || node.name == "redCoin" {
                    self.currentNode = node
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = self.currentNode {
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = self.currentNode {
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
            if node.name == "blueCoin" {
                        if blueChest.frame.contains(node.position){
                            let points = Int(node.frame.height)
                            let currentScore = score
                            score = currentScore + points
                            
                            if let particles = SKEmitterNode(fileNamed: "treasureadded"){
                                particles.position = blueChest.position
                                addChild(particles)
                                
                                let removeParticles = SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.removeFromParent()])
                                
                                particles.run(removeParticles)
                            }
                            node.removeFromParent()
                        }
                        else if background.frame.contains(node.position)
                                    && !redChest.frame.contains(node.position)
                                    && !greenChest.frame.contains(node.position)
                                    && !yellowChest.frame.contains(node.position){
                            
                        }
                        else{
                            lives = lives - 1
                            node.removeFromParent()
                            if lives == 0{
                                gameOver()
                            }
                        }
                    }
            
                    if node.name == "yellowCoin" {
                        if yellowChest.frame.contains(node.position){
                            let points = Int(node.frame.height)
                            let currentScore = score
                            score = currentScore + points
                            
                            if let particles = SKEmitterNode(fileNamed: "treasureadded"){
                                particles.position = yellowChest.position
                                addChild(particles)
                                
                                let removeParticles = SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.removeFromParent()])
                                
                                particles.run(removeParticles)
                            }
                            
                            node.removeFromParent()
                        }
                        else if background.frame.contains(node.position)
                                    && !redChest.frame.contains(node.position)
                                    && !blueChest.frame.contains(node.position)
                                    && !greenChest.frame.contains(node.position){
                            
                        }
                        else{
                            lives = lives - 1
                            node.removeFromParent()
                            if lives == 0{
                                gameOver()
                            }
                        }
                    }
            
                    if node.name == "redCoin" {
                        if redChest.frame.contains(node.position){
                            let points = Int(node.frame.height)
                            let currentScore = score
                            score = currentScore + points
                            
                            if let particles = SKEmitterNode(fileNamed: "treasureadded"){
                                particles.position = redChest.position
                                addChild(particles)
                                
                                let removeParticles = SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.removeFromParent()])
                                
                                particles.run(removeParticles)
                            }
                            node.removeFromParent()
                        }
                        else if background.frame.contains(node.position)
                                    && !greenChest.frame.contains(node.position)
                                    && !blueChest.frame.contains(node.position)
                                    && !yellowChest.frame.contains(node.position){
                            
                        }
                        else{
                            lives = lives - 1
                            node.removeFromParent()
                            if lives == 0{
                                gameOver()
                            }
                        }
                    }
            
                    if node.name == "greenCoin" {
                        if greenChest.frame.contains(node.position){
                            let points = Int(node.frame.height)
                            let currentScore = score
                            score = currentScore + points
                            
                            if let particles = SKEmitterNode(fileNamed: "treasureadded"){
                                particles.position = greenChest.position
                                addChild(particles)
                                
                                let removeParticles = SKAction.sequence([SKAction.wait(forDuration: 1.5), SKAction.removeFromParent()])
                                
                                particles.run(removeParticles)
                            }
                            node.removeFromParent()
                        }
                        else if background.frame.contains(node.position)
                                    && !redChest.frame.contains(node.position)
                                    && !blueChest.frame.contains(node.position)
                                    && !yellowChest.frame.contains(node.position){
                            
                        }
                        else{
                            lives = lives - 1
                            node.removeFromParent()
                            if lives == 0{
                                gameOver()
                            }
                        }
                    }
        }

    }
    
    func gameOver(){
        stopTimerTest()
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.zPosition = 9200
        gameOver.xScale = 0.1
        gameOver.yScale = 0.1
        addChild(gameOver)
        
        let appear = SKAction.group([SKAction.scale(to: 2, duration: 0.25), SKAction.fadeIn(withDuration: 0.75)])
        //let disappear = SKAction.group([SKAction.scale(to: 2, duration: 0.25), SKAction.fadeOut(withDuration: 5)])
        let sequence = SKAction.sequence([appear, SKAction.wait(forDuration: 0.25)])
        gameOver.run(sequence)
        isGameOver = true
        playSound(sound: "gameOver", type: "mp3")
    }
    
    func endGame(){
            // restart the game
            let gameScene = openingScene(size: self.size)
            stopSound(sound: "music1", type: "mp3")
            self.view!.presentScene(gameScene)
        }
    
    func setupLabels(){
        scoreLabel.fontSize = 25
        scoreLabel.position = CGPoint(x: frame.midX - 25, y: frame.maxY - 20)
        scoreLabel.text = "SCORE: 0"
        scoreLabel.zPosition = 100
        addChild(scoreLabel)
        
        livesLabel.fontSize = 25
        livesLabel.position = CGPoint(x: frame.midX + scoreLabel.frame.width + 25, y: frame.maxY - 20)
        livesLabel.text = "LIVES: 3"
        livesLabel.zPosition = 100
        addChild(livesLabel)
    }
    
    @objc func setupChests(){
    
        if chestChange >= 1{
            changeChests()
        }
        chestChange += 1
        
        greenChest.removeFromParent()
        blueChest.removeFromParent()
        redChest.removeFromParent()
        yellowChest.removeFromParent()

        let position1 = CGPoint(x: greenChest.frame.width + 20, y: frame.maxY - 50)
        let position2 = CGPoint(x: blueChest.frame.width + 20, y: frame.minY + 50)
        let position3 = CGPoint(x: frame.maxX - redChest.frame.width + 20, y: frame.minY + 50)
        let position4 = CGPoint(x: frame.maxX - yellowChest.frame.width + 20, y: frame.maxY - 50)
        var positions = [position1, position2, position3, position4]
        
        positions.shuffle()
                
        greenChest.zPosition = -1
        greenChest.position = positions[0]
        addChild(greenChest)
        
        blueChest.zPosition = -1
        blueChest.position = positions[1]
        addChild(blueChest)
        
        redChest.zPosition = -1
        redChest.position = positions[2]
        addChild(redChest)
        
        yellowChest.zPosition = -1
        yellowChest.position = positions[3]
        addChild(yellowChest)
    }
    
    func changeChests(){
        let changeChests = SKSpriteNode(imageNamed: "chestChange")
        changeChests.position = CGPoint(x: frame.midX, y: frame.midY)
        changeChests.zPosition = 9200
        changeChests.xScale = 0.1
        changeChests.yScale = 0.1
        addChild(changeChests)
        
        let appear = SKAction.group([SKAction.scale(to: 2, duration: 0.25), SKAction.fadeIn(withDuration: 0.75)])
        let disappear = SKAction.group([SKAction.scale(to: 2, duration: 0.25), SKAction.fadeOut(withDuration: 0.75)])
        let sequence = SKAction.sequence([appear, SKAction.wait(forDuration: 0.25), disappear])

        playSoundEffect(sound: "chestSwap", type: "mp3")
        changeChests.run(sequence)
    }
    
    func scheduledTimerWithTimeInterval(interval: Int){
        // Scheduling timer to Call the function "updateCounting" with the interval of 30 seconds
        guard timer == nil else { return }

        timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval), target: self, selector: #selector(self.setupChests), userInfo: nil, repeats: true)
    }
    
    func stopTimerTest() {
      timer?.invalidate()
      timer = nil
    }
    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if coin.name == "blueCoin" {
//            if blueChest.frame.contains(coin.position){
//                coin.removeFromParent()
//            }
//        }
//
//        if coin.name == "yellowCoin" {
//            if yellowChest.frame.contains(coin.position){
//                coin.removeFromParent()
//            }
//        }
//
//        if coin.name == "redCoin" {
//            if redChest.frame.contains(coin.position){
//                coin.removeFromParent()
//            }
//        }
//
//        if coin.name == "greenCoin" {
//            if greenChest.frame.contains(coin.position){
//                coin.removeFromParent()
//            }
//        }
//    }

}
