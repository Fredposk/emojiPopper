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
//            checkTouches(touches)
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
}
