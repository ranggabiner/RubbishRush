//
//  GameView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        ZStack {
            Image("GameBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                HStack {
                    Image("OrganicBin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width / 4.2)
                    Image("GlassBin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width / 4.2)
                    Image("PlasticBin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width / 4.2)
                    Image("PaperBin")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIScreen.main.bounds.width / 4.2)
                }
                .padding(.bottom, UIScreen.main.bounds.height / 40)
            }
            
            VStack {
                HStack {
                    Button(action: {
                        gameViewModel.showPopup = true
                    }) {
                        Image(systemName: "arrowshape.backward.circle")
                            .foregroundStyle(.black)
                            .font(.system(size: 42))
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "pause.circle")
                            .foregroundStyle(.black)
                            .font(.system(size: 42))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top)
                .padding(.top, 48)
                Spacer()
            }
            
            if gameViewModel.showPopup {
                BackValidationView()
            }
        }
        .navigationBarBackButtonHidden()
    }
}
