//
//  SoundManager.swift
//  STEPN Sidekick
//
//  Created by Rob Godfrey on 8/16/22.
//

import Foundation
import AVKit

class SoundManager {
    
    static let instance = SoundManager()
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case alert_sound
        case avg_speed
    }
    
    func playSound(sound: SoundOption) {
        guard let url  = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("playin from class!")
        } catch let error {
            print("error playing sound... \(error.localizedDescription)")
        }
    }
}
