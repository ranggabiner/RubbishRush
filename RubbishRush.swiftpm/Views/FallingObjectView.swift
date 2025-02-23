//
//  FallingObjectView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 23/02/25.
//

import SwiftUI

// MARK: - FallingObjectView
/// View untuk menampilkan objek jatuh dan meng-handle drag gesture.
struct FallingObjectView: View {
    @Binding var object: FallingObject      // Binding ke model objek jatuh
    let laneWidth: CGFloat                  // Lebar tiap lane
    let objectSize: CGFloat                 // Ukuran objek
    let lanesCount: Int                     // Jumlah total lane

    @State private var dragOffset: CGFloat = 0   // Offset horizontal saat drag

    var body: some View {
        Image(object.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: objectSize)
            // Posisi dihitung berdasarkan lane center + offset saat drag.
            .position(
                x: laneWidth * (CGFloat(object.lane) + 0.5) + dragOffset,
                y: object.yPosition
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Update offset horizontal secara realtime saat drag.
                        dragOffset = value.translation.width
                    }
                    .onEnded { _ in
                        // Hitung pergeseran lane berdasarkan offset drag.
                        let laneChange = Int(round(dragOffset / laneWidth))
                        // Update lane, pastikan nilai berada dalam batas yang valid.
                        object.lane = min(max(object.lane + laneChange, 0), lanesCount - 1)
                        // Reset drag offset.
                        dragOffset = 0
                    }
            )
    }
}
