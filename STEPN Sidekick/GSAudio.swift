//
//  GSAudio.swift
//  STEPN Sidekick
//
//  Adpated from class created by Olivier Wilkinson and updated for Swift 4 by Makalele
//
//  Created by Rob Godfrey
//  Last updated 27 Aug 22
//

import Foundation
import AVKit

class GSAudio: NSObject, AVAudioPlayerDelegate {

    static let sharedInstance = GSAudio()

    private override init() { }

    var players: [URL: AVAudioPlayer] = [:]
    var duplicatePlayers: [AVAudioPlayer] = []
    
    enum SoundOption: String {
        case alert_sound
        case alert_sound_slow
        case avg_speed
        case current_speed
        case eight
        case eighteen
        case eleven
        case fifteen
        case fifty
        case five
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

        guard let bundle = Bundle.main.path(forResource: sound.rawValue, ofType: "mp3") else { return }
        let soundFileNameURL = URL(fileURLWithPath: bundle)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback,  mode: .default, options: .mixWithOthers)
        } catch let error {
            print("RUH ROH! \(error.localizedDescription)")
        }

        if let player = players[soundFileNameURL] { //player for sound has been found

            if !player.isPlaying { //player is not in use, so use that one
                
                player.prepareToPlay()
                player.play()
                
            } else { // player is in use, create a new, duplicate, player and use that instead

                do {
                    let duplicatePlayer = try AVAudioPlayer(contentsOf: soundFileNameURL)

                    duplicatePlayer.delegate = self
                    //assign delegate for duplicatePlayer so delegate can remove the duplicate once it's stopped playing

                    duplicatePlayers.append(duplicatePlayer)
                    //add duplicate to array so it doesn't get removed from memory before finishing

                    duplicatePlayer.prepareToPlay()
                    duplicatePlayer.play()
                } catch let error {
                    print(error.localizedDescription)
                }

            }
        } else { //player has not been found, create a new player with the URL if possible
            do {
                let player = try AVAudioPlayer(contentsOf: soundFileNameURL)
                players[soundFileNameURL] = player
                player.prepareToPlay()
                player.play()
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if let index = duplicatePlayers.firstIndex(of: player) {
            duplicatePlayers.remove(at: index)
        }
    }

}
