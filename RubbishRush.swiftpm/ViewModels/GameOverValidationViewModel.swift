//
//  GameOverValidationViewModel.swift
//  RubbishRush
//
//  Created by Rangga Biner on 21/02/25.
//

import Foundation
import AVFoundation


class GameOverValidationViewModel: ObservableObject {
    @Published var isPressedRestart = false
    @Published var isPressedBackToHome = false
    var audioPlayer: AVAudioPlayer?

    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "button_sound", withExtension: "wav") else {
            print("Sound file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
        } catch {
            print("Failed to play sound: \(error.localizedDescription)")
        }
    }

}
