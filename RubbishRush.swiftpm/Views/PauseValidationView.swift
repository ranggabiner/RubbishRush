//
//  PauseValidationView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import SwiftUI

struct PauseValidationView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var pauseValidationViewModel: PauseValidationViewModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            VStack {
                Text("Paused")
                    .foregroundStyle(.white)
                    .font(.system(size: 70, weight: .bold))
                    .padding(.bottom, 45)
                
                ZStack {
                    Text("CONTINUE")
                        .padding(.vertical, 16)
                        .padding(.horizontal, 78)
                        .background(Color("greenSecondary"))
                        .foregroundColor(.clear)
                        .font(.system(size: 32, weight: .heavy))
                        .cornerRadius(32)
                        .padding(.top, 20)
                        .scaleEffect(pauseValidationViewModel.isPressedContinue ? 0.9 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: pauseValidationViewModel.isPressedContinue)

                    Button {
                        gameViewModel.showPopupPause = false
                    } label: {
                        Text("CONTINUE")
                            .padding(.vertical, 16)
                            .padding(.horizontal, 78)
                            .background(Color("greenPrimary"))
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .heavy))
                            .cornerRadius(32)
                            .scaleEffect(pauseValidationViewModel.isPressedContinue ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: pauseValidationViewModel.isPressedContinue)
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            pauseValidationViewModel.isPressedContinue = true
                        }
                        .onEnded { _ in
                            pauseValidationViewModel.isPressedContinue = false
                            pauseValidationViewModel.playSound()
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
                        .scaleEffect(pauseValidationViewModel.isPressedBackToHome ? 0.9 : 1.0)
                        .animation(.easeInOut(duration: 0.2), value: pauseValidationViewModel.isPressedBackToHome)

                    Button {
                        homeViewModel.navigationPath = NavigationPath()
                        gameViewModel.showPopupPause = false
                    } label: {
                        Text("BACK TO HOME")
                            .padding(.vertical, 16)
                            .padding(.horizontal, 78)
                            .background(Color("yellowPrimary"))
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .heavy))
                            .cornerRadius(32)
                            .scaleEffect(pauseValidationViewModel.isPressedBackToHome ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: pauseValidationViewModel.isPressedBackToHome)
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            pauseValidationViewModel.isPressedBackToHome = true
                        }
                        .onEnded { _ in
                            pauseValidationViewModel.isPressedBackToHome = false
                            pauseValidationViewModel.playSound()
                        }
                )
            }
        }
    }
}
