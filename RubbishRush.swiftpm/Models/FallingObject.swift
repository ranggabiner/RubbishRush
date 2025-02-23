//
//  FallingObject.swift
//  RubbishRush
//
//  Created by Rangga Biner on 23/02/25.
//

import SwiftUI

/// Model yang merepresentasikan objek jatuh.
struct FallingObject: Identifiable {
    let id = UUID()              // Identifier unik
    var lane: Int                // Indeks lane (0 sampai lanesCount-1)
    var yPosition: CGFloat       // Posisi vertikal di layar
    var type: FallingObjectType  // Jenis objek
    var imageName: String        // Nama gambar yang dipilih acak
    
    init(lane: Int, yPosition: CGFloat, type: FallingObjectType) {
        self.lane = lane
        self.yPosition = yPosition
        self.type = type
        // Pilih gambar secara acak dari daftar gambar yang tersedia untuk tipe tersebut.
        self.imageName = type.imageNames.randomElement() ?? ""
    }
}
