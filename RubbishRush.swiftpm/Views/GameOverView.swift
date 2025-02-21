//
//  GameOverView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 21/02/25.
//

import SwiftUI
import AVFoundation

/// Tampilan popup Game Over dengan tombol restart dan kembali ke home.
struct GameOverView: View {
    var onRestart: () -> Void  // Closure yang akan dipanggil ketika restart ditekan
    @EnvironmentObject var gameOverValidationViewModel: GameOverValidationViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            VStack {
                Text("GAME OVER")
                    .foregroundStyle(.white)
                    .font(.system(size: 70, weight: .bold))
                    .padding(.bottom, 45)
                
                ZStack {
                    // Teks tombol restart sebagai background
                    Text("RESTART")
                        .padding(.vertical, 16)
                        .padding(.horizontal, 78)
                        .background(Color("greenSecondary"))
                        .foregroundColor(.clear)
                        .font(.system(size: 32, weight: .heavy))
                        .cornerRadius(32)
                        .padding(.top, 9)
                        .scaleEffect(gameOverValidationViewModel.isPressedRestart ? 0.9 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: gameOverValidationViewModel.isPressedRestart)
                    
                    // Tombol restart yang memanggil onRestart()
                    Button {
                        onRestart()
                    } label: {
                        Text("RESTART")
                            .padding(.vertical, 16)
                            .padding(.horizontal, 78)
                            .background(Color("greenPrimary"))
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .heavy))
                            .cornerRadius(32)
                            .padding(.bottom)
                            .scaleEffect(gameOverValidationViewModel.isPressedRestart ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: gameOverValidationViewModel.isPressedRestart)
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            gameOverValidationViewModel.isPressedRestart = true
                        }
                        .onEnded { _ in
                            gameOverValidationViewModel.isPressedRestart = false
                            gameOverValidationViewModel.playSound()
                        }
                )
                
                ZStack {
                    Text("BACK TO HOME")
                        .padding(.vertical, 16)
                        .padding(.horizontal, 78)
                        .background(Color("yellowSecondary"))
                        .foregroundColor(.clear)
                        .font(.system(size: 32, weight: .heavy))
                        .cornerRadius(32)
                        .padding(.top, 20)
                        .scaleEffect(gameOverValidationViewModel.isPressedBackToHome ? 0.9 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: gameOverValidationViewModel.isPressedBackToHome)
                    
                    Button {
                        // Kosongkan navigationPath untuk kembali ke HomeView
                        homeViewModel.navigationPath = NavigationPath()
                        gameViewModel.showPopupGameOver = false
                    } label: {
                        Text("BACK TO HOME")
                            .padding(.vertical, 16)
                            .padding(.horizontal, 78)
                            .background(Color("yellowPrimary"))
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .heavy))
                            .cornerRadius(32)
                            .scaleEffect(gameOverValidationViewModel.isPressedBackToHome ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: gameOverValidationViewModel.isPressedBackToHome)
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            gameOverValidationViewModel.isPressedBackToHome = true
                        }
                        .onEnded { _ in
                            gameOverValidationViewModel.isPressedBackToHome = false
                            gameOverValidationViewModel.playSound()
                        }
                )
            }
        }
    }
}

