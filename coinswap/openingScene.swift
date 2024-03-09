//
//  openingScene.swift
//  coinswap
//
//  Created by Ryan Replogle on 11/30/20.
//

import SpriteKit

class openingScene: SKScene {

    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "blueChest")
    let startGameText = SKLabelNode(fontNamed: "Helvetica")
    let titleText = SKLabelNode(fontNamed: "Helvetica")


    override func didMove(to view: SKView) {
        playSound(sound: "music2", type: "mp3")
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(playButton)
        
        startGameText.fontSize = 25
        startGameText.text = "CLICK TO START"
        startGameText.position = CGPoint(x: playButton.position.x, y: playButton.position.y - 80)
        self.addChild(startGameText)
        
        titleText.fontSize = 45
        titleText.text = "COIN SWAP"
        titleText.position = CGPoint(x: playButton.position.x, y: playButton.position.y + 80)
        self.addChild(titleText)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)

            if node == playButton {
                if view != nil {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    self.view?.presentScene(scene, transition: transition)
                }
            }
        }
    }
}
