//
//  SoundManager.swift
//  TapCoinsApplication
//
//  Created by Eric Viera on 3/14/24.
//

import Foundation
import AVKit
import SwiftUI

// initialization: SoundManager.instance.playSound()

class SoundManager{
    @AppStorage("sounds") var sound_on:Bool?
    
    static let instance = SoundManager()
    
    var player: AVAudioPlayer?
    
    func playSound(sound_link:String){
        if (self.sound_on ?? true){
            guard let url = Bundle.main.url(forResource: sound_link, withExtension: "mp3") else { return }
            do {
                try AVAudioSession.sharedInstance().setCategory(
                    AVAudioSession.Category.playback,
                    options: AVAudioSession.CategoryOptions.mixWithOthers
                )
                
                try AVAudioSession.sharedInstance().setActive(true)
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            }
            catch let error{
                print("NO SOUND: \(error.localizedDescription) ******")
            }
        }
    }
}
