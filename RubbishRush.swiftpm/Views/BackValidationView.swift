//
//  BackValidationView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import SwiftUI

struct BackValidationView: View {
    @EnvironmentObject var backValidationViewModel: BackValidationViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel
    @EnvironmentObject var gameViewModel: GameViewModel

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            
            VStack {
                Text("You want to quit?")
                    .foregroundStyle(.white)
                    .font(.system(size: 70, weight: .bold))
                    .padding(.bottom, 45)
                
                ZStack {
                    Text("YES")
                        .padding(.vertical, 16)
                        .padding(.horizontal, 78)
                        .background(Color("greenSecondary"))
                        .foregroundColor(.clear)
                        .font(.system(size: 32, weight: .heavy))
                        .cornerRadius(32)
                        .padding(.top, 9)
                    
                    Button {
                        // Kosongkan navigationPath untuk kembali ke HomeView
                        homeViewModel.navigationPath = NavigationPath()
                        gameViewModel.showPopup = false
                        
                    } label: {
                        Text("YES")
                            .padding(.vertical, 16)
                            .padding(.horizontal, 78)
                            .background(Color("greenPrimary"))
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .heavy))
                            .cornerRadius(32)
                            .padding(.bottom)
                            .scaleEffect(backValidationViewModel.isPressedYes ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: backValidationViewModel.isPressedYes)
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            backValidationViewModel.isPressedYes = true
                        }
                        .onEnded { _ in
                            backValidationViewModel.isPressedYes = false
                            backValidationViewModel.playSound()
                        }
                )
                
                ZStack {
                    Text("NO")
                        .padding(.vertical, 16)
                        .padding(.horizontal, 78)
                        .background(Color("greenSecondary"))
                        .foregroundColor(.clear)
                        .font(.system(size: 32, weight: .heavy))
                        .cornerRadius(32)
                        .padding(.top, 20)
                    
                    Button {
                        gameViewModel.showPopup = false
                    } label: {
                        Text("NO")
                            .padding(.vertical, 16)
                            .padding(.horizontal, 78)
                            .background(Color("greenPrimary"))
                            .foregroundColor(.white)
                            .font(.system(size: 32, weight: .heavy))
                            .cornerRadius(32)
                            .scaleEffect(backValidationViewModel.isPressedNo ? 0.9 : 1.0)
                            .animation(.easeInOut(duration: 0.2), value: backValidationViewModel.isPressedNo)
                    }
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            backValidationViewModel.isPressedNo = true
                        }
                        .onEnded { _ in
                            backValidationViewModel.isPressedNo = false
                            backValidationViewModel.playSound()
                        }
                )
            }
        }
    }
}
