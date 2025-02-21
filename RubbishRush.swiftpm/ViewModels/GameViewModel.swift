//
//  GameViewModel.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var showPopupPause = false
    @Published var showPopupGameOver = false
    @Published var isPressed = false
    @AppStorage("HighScore") var highScore: Int = 0
}
