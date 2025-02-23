//
//  SoudManager.swift
//  RubbishRush
//
//  Created by Rangga Biner on 23/02/25.
//


import AVFoundation

class SoundManager: ObservableObject {
    @Published var isSoundOn: Bool = true
    var audioPlayer: AVAudioPlayer?
    
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
}
