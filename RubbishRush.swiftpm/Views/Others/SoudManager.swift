//
//  SoudManager.swift
//  RubbishRush
//
//  Created by Rangga Biner on 23/02/25.
//

import AVFoundation
import SwiftUI

class SoundManager: ObservableObject {
    @Published var isSoundOn: Bool = true
    var audioPlayer: AVAudioPlayer?
    
    var correctSoundPlayer: AVAudioPlayer?
    var incorrectSoundPlayer: AVAudioPlayer?
    
    func playBackgroundMusic() {
        guard isSoundOn,
              let url = Bundle.main.url(forResource: "guitar", withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.play()
        } catch {
            print("Error saat memainkan musik: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
    
    func toggleSound() {
        isSoundOn.toggle()
        if isSoundOn {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }
    
    func playCorrectSound() {
        guard isSoundOn,
              let url = Bundle.main.url(forResource: "correct", withExtension: "mp3") else {
            return
        }
        do {
            correctSoundPlayer = try AVAudioPlayer(contentsOf: url)
            correctSoundPlayer?.play()
        } catch {
            print("Error saat memainkan efek suara benar: \(error.localizedDescription)")
        }
    }
    
    func playIncorrectSound() {
        guard isSoundOn,
              let url = Bundle.main.url(forResource: "incorrect", withExtension: "mp3") else {
            return
        }
        do {
            incorrectSoundPlayer = try AVAudioPlayer(contentsOf: url)
            incorrectSoundPlayer?.play()
        } catch {
            print("Error saat memainkan efek suara salah: \(error.localizedDescription)")
        }
    }
}
