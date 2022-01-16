//
//  Scene.swift
//  EmojiPop
//
//  Created by Frederico Kuckelhaus on 13.01.22.
//

import SpriteKit
import ARKit

enum GameState {
    case Init, TapToStart, Playing, GameOver
}

class Scene: SKScene {

    var gameState: GameState = GameState.Init
    var anchor: ARAnchor?
    var emojis: String = "😎😅🔥😆😇🥸🚀"
    var spawnTime: TimeInterval = 0
    var score: Int = 0
    var lives: Int = 10




    override func didMove(to view: SKView) {
        startGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if gameState != .Playing { return }

        if spawnTime == 0 { spawnTime = currentTime + 3 }
        if spawnTime < currentTime {
            spawnEmoji()
            spawnTime = currentTime + 0.5
        }
        updateHud(with: "SCORE: " + "\(score)" + " | LIVES: " + "\(lives)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        switch gameState {
        case .Init:
            break
        case .TapToStart:
            playGame()
            addAnchor()
            break
        case .Playing:
            checkTouches(touches)
            break
        case .GameOver:
            startGame()
            break
        }
    }

    func updateHud(with message: String) {
        guard let sceneView = self.view as? ARSKView else { return }

        let viewController = sceneView.delegate as! ViewController
        viewController.hudLabel.text = message
    }

    func startGame() {
        gameState = .TapToStart
        updateHud(with: "- TAP TO START -")
    }

    func playGame() {
        gameState = .Playing
        score = 0
        lives = 10
        spawnTime = 0
        removeAnchor()
    }

    func stopGame() {
        gameState = .GameOver
        updateHud(with: "GAME OVER! SCORE: \(score)")
    }

    func addAnchor() {
        guard let sceneView = self.view as? ARSKView else { return }

        if let currentFrame = sceneView.session.currentFrame {

            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.5
            let transform = simd_mul(currentFrame.camera.transform, translation)

            // Add a new anchor to the session
            let anchor = ARAnchor(transform: transform)
            sceneView.session.add(anchor: anchor)
        }
    }

    func removeAnchor() {
        guard let sceneView = self.view as? ARSKView else { return }

        if anchor != nil {
            sceneView.session.remove(anchor: anchor!)
        }
    }

    func spawnEmoji() {
        let emojiNode = SKLabelNode(text: String(emojis.randomElement()!))
        emojiNode.name = "Emoji"
        emojiNode.horizontalAlignmentMode = .center
        emojiNode.verticalAlignmentMode = .center

        guard let sceneView = self.view as? ARSKView else { return }
        let spawnNode = sceneView.scene?.childNode(withName: "SpawnPoint")
        spawnNode?.addChild(emojiNode)
        emojiNode.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        emojiNode.physicsBody?.mass = 0.01
        emojiNode.physicsBody?.applyImpulse(CGVector(dx: -5 + 10 * randomCGFloat(), dy: 10))
        emojiNode.physicsBody?.applyTorque(-0.2 + 0.4 * randomCGFloat())

        let runAction = SKAction.run {
            self.lives -= 1
            if self.lives <= 0 {
                self.stopGame()
            }
        }

         let sequenceAction = SKAction.sequence([
            Actions.spawnSoundAction, Actions.waitAction, Actions.dieSoundAction, runAction, Actions.removeAction
        ])

        emojiNode.run(sequenceAction)

    }

    func checkTouches(_ touch: Set<UITouch>) {
        guard let touch = touch.first else { return }
        let touchLocation = touch.location(in: self)
        let touchedNode = self.atPoint(touchLocation)

        if touchedNode.name != "Emoji" { return }
        let sequenceAction = SKAction.sequence([
            Actions.collectionSoundAction, Actions.removeAction
        ])
        touchedNode.run(sequenceAction)
    }

    func randomCGFloat() -> CGFloat {
        return CGFloat(Float.random(in: 0.0...1.0))
    }






}
