//
//  BackValidationViewModel.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import Foundation
import AVFoundation

class BackValidationViewModel: ObservableObject {
    @Published var isPressedYes = false
    @Published var isPressedNo = false
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
