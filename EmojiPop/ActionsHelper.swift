//
//  ActionsHelper.swift
//  EmojiPop
//
//  Created by Frederico Kuckelhaus on 16.01.22.
//

import ARKit


enum Actions {
    static let spawnSoundAction = SKAction.playSoundFileNamed("SoundEffects/Spawn.wav", waitForCompletion: false)
    static let dieSoundAction = SKAction.playSoundFileNamed("SoundEffects/Die.wav", waitForCompletion: false)
    static let waitAction = SKAction.wait(forDuration: 3)
    static let removeAction = SKAction.removeFromParent()
    static let collectionSoundAction = SKAction.playSoundFileNamed("SoundEffects/Die.wav", waitForCompletion: false)
    static let startSoundAction = SKAction.playSoundFileNamed("SoundEffects/GameStart.wav", waitForCompletion: false)
    static let scaleInAction = SKAction.scale(to: 1.5, duration: 0.8)
}
