//
//  HomeView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import SwiftUI
import AVFoundation

struct HomeView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        NavigationStack(path: $homeViewModel.navigationPath) {
            ZStack {
                Image("HomeBackground")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Text("RUBBISH \n RUSH")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)
                        .font(.title)
                        .fontWeight(.bold)
                        .italic()
                        .padding(.top, UIScreen.main.bounds.height / 9)
                        .padding(.bottom)
                    
                    Text("High Score \n \(gameViewModel.highScore)")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white)
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                    Spacer()
                    ZStack {
                        Text("PLAY")
                            .padding(.vertical, 16)
                            .padding(.horizontal, 78)
                            .background(Color("greenSecondary"))
                            .foregroundColor(.clear)
                            .font(.system(size: 32, weight: .heavy))
                            .cornerRadius(32)
                            .padding(.bottom, UIScreen.main.bounds.height / 5.6)
                            .scaleEffect(homeViewModel.isPressed ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: homeViewModel.isPressed)

                        NavigationLink(value: "GameView") {
                            Text("PLAY")
                                .padding(.vertical, 16)
                                .padding(.horizontal, 78)
                                .background(Color("greenPrimary"))
                                .foregroundColor(.white)
                                .font(.system(size: 32, weight: .heavy))
                                .cornerRadius(32)
                                .padding(.bottom, UIScreen.main.bounds.height / 5)
                                .scaleEffect(homeViewModel.isPressed ? 0.9 : 1.0)
                                .animation(.easeInOut(duration: 0.2), value: homeViewModel.isPressed)
                        }
                    }
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                homeViewModel.isPressed = true
                            }
                            .onEnded { _ in
                                homeViewModel.isPressed = false
                                homeViewModel.playSound()
                            }
                    )
                }
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "GameView" {
                    GameView()
                }
            }
        }
    }
}
