//
//  audioHelpers.swift
//  coinswap
//
//  Created by Ryan Replogle on 11/30/20.
//

import Foundation
import AVFoundation

var audioPlayer: AVAudioPlayer?
var audioPlayer2: AVAudioPlayer?

func playSoundEffect(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer2 = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer2?.play()
        }
        catch{
            
        }
    }
}

func playSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        }
        catch{
            
        }
    }
}

func pauseSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.pause()
        }
        catch{
            
        }
    }
}

func stopSound(sound: String, type: String) {
    if let path = Bundle.main.path(forResource: sound, ofType: type){
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.stop()
        }
        catch{
            
        }
    }
}
