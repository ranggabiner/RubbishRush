//
//  GameViewModel.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var showPopupBack = false
    @Published var showPopupPause = false
    @Published var isPressed = false
}
