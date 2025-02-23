//
//  FallingObjectView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 23/02/25.
//

import SwiftUI

struct FallingObjectView: View {
    @Binding var object: FallingObject
    let laneWidth: CGFloat
    let objectSize: CGFloat
    let lanesCount: Int

    @State private var dragOffset: CGFloat = 0 

    var body: some View {
        Image(object.imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: objectSize)
            .position(
                x: laneWidth * (CGFloat(object.lane) + 0.5) + dragOffset,
                y: object.yPosition
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                       dragOffset = value.translation.width
                    }
                    .onEnded { _ in
                        let laneChange = Int(round(dragOffset / laneWidth))
                        object.lane = min(max(object.lane + laneChange, 0), lanesCount - 1)
                        dragOffset = 0
                    }
            )
    }
}
