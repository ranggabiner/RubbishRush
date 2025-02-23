//
//  FallingObjectTypeExtension.swift
//  RubbishRush
//
//  Created by Rangga Biner on 23/02/25.
//

import Foundation

enum FallingObjectType: CaseIterable {
    case type1, type2, type3, type4
}

extension FallingObjectType {
    var description: String {
        switch self {
        case .type1: return "Organic"
        case .type2: return "Glass"
        case .type3: return "Plastic"
        case .type4: return "Paper"
        }
    }
    
    var imageNames: [String] {
        switch self {
        case .type1:
            return ["AppleTrash", "BananaTrash", "ChickenTrash", "FishTrash", "WatermelonTrash"]
        case .type2:
            return ["BottleGlassTrash", "GlassCrackTrash", "GlassTrash", "PlateTrash", "LampTrash"]
        case .type3:
            return ["FaceWashTrash", "InfusionBottle", "PlasticBagTrash", "PlasticBottleTrash", "PlasticGlassTrash"]
        case .type4:
            return ["BookTrash", "MagazineTrash", "MailTrash", "PaperBoxTrash", "SmallPaperBoxTrash"]
        }
    }
}
