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
    var playing: Bool = true
    var player: AVAudioPlayer?
    
    enum SoundOption: String {
        case alert_sound
        case avg_speed
        case current_speed
        case eight
        case eighteen
        case eleven
        case fifteen
        case fifty
        case five_mid
        case forty
        case four
        case fourteen
        case kilo_per_hour
        case minutes
        case nine
        case nineteen
        case one_hour_end
        case one_hour
        case one_minute_remaining
        case one
        case over_twenty
        case point
        case seventeen
        case sevn // misspelled from the android version, but it stays
        case six
        case sixteen
        case soft_alert_sound
        case start_sound
        case ten
        case thirteen
        case thirty_seconds_remaining
        case thirty
        case three
        case time_remaining
        case twelve
        case twenty
        case two_hours_end
        case two_hours
        case two
        case zero
    }
    
    func playSound(sound: SoundOption) {
        guard let url  = Bundle.main.url(forResource: sound.rawValue, withExtension: ".mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,  mode: .default, options: .mixWithOthers)
        } catch let error {
            print("RUH ROH! \(error.localizedDescription)")
        }
        
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("oh no!! \(error.localizedDescription)")
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            print("playin from class!")
        } catch let error {
            print("error playing sound... \(error.localizedDescription)")
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playing = false
    }
}

