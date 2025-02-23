//
//  FallingObject.swift
//  RubbishRush
//
//  Created by Rangga Biner on 23/02/25.
//

import SwiftUI

struct FallingObject: Identifiable {
    let id = UUID()
    var lane: Int
    var yPosition: CGFloat
    var type: FallingObjectType
    var imageName: String
    
    init(lane: Int, yPosition: CGFloat, type: FallingObjectType) {
        self.lane = lane
        self.yPosition = yPosition
        self.type = type
        self.imageName = type.imageNames.randomElement() ?? ""
    }
}
