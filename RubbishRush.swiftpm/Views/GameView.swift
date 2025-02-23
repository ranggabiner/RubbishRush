//
//  GameView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import SwiftUI
import AVFoundation

struct GameView: View {
    @EnvironmentObject var gameViewModel: GameViewModel
    @EnvironmentObject var soundManager: SoundManager

    let lanesCount: Int = 4
    let objectSize: CGFloat = UIScreen.main.bounds.width / 8
    let fallingSpeed: CGFloat = 3
    let maxHealth: CGFloat = 100
    
    @State private var showPlusOne: [Bool] = Array(repeating: false, count: 4)
    @State private var showWrong: [Bool] = Array(repeating: false, count: 4)
    
    @State private var fallingObjects: [FallingObject] = [
        FallingObject(lane: 0, yPosition: -100, type: .type1),
        FallingObject(lane: 1, yPosition: -300, type: .type2),
        FallingObject(lane: 2, yPosition: -500, type: .type3),
        FallingObject(lane: 3, yPosition: -700, type: .type4)
    ]
    @State private var health: CGFloat = 100
    
    private func correctLane(for type: FallingObjectType) -> Int {
        FallingObjectType.allCases.firstIndex(of: type) ?? 0
    }
    
    private func randomLane(excluding excludedLane: Int) -> Int {
        var availableLanes = Array(0..<lanesCount)
        availableLanes.removeAll { $0 == excludedLane }
        return availableLanes.randomElement()!
    }
    
    private func resetGame() {
        gameViewModel.score = 0
        health = maxHealth
        
        for index in fallingObjects.indices {
            fallingObjects[index].yPosition = -objectSize / 2 - CGFloat(index) * 200
            let correct = correctLane(for: fallingObjects[index].type)
            fallingObjects[index].lane = randomLane(excluding: correct)
        }
        
        gameViewModel.showPopupGameOver = false
    }
    
    private func triggerPlusOne(for lane: Int) {
        withAnimation {
            showPlusOne[lane] = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showPlusOne[lane] = false
            }
        }
    }
    
    private func triggerWrong(for lane: Int) {
        withAnimation {
            showWrong[lane] = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                showWrong[lane] = false
            }
        }
    }
    
    private var binImages: [String] {
        ["OrganicBin", "GlassBin", "PlasticBin", "PaperBin"]
    }
    
    var body: some View {
        ZStack {
            Image("GameBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                let laneWidth = geometry.size.width / CGFloat(lanesCount)
                let screenHeight = geometry.size.height
                let binsHeight: CGFloat = 120
                
                ZStack {
                    VStack(spacing: 10) {
                        HStack {
                            Button(action: {
                                soundManager.toggleSound()
                            }) {
                                Image(systemName: soundManager.isSoundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            Button(action: { gameViewModel.showPopupPause = true }) {
                                Image(systemName: "pause.circle")
                                    .font(.system(size: 52))
                                    .foregroundColor(.black)
                            }
                        }
                        .padding(.horizontal, 28)
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("High Score: \(gameViewModel.highScore)")
                                    .font(.system(size: 26))
                                    .fontWeight(.bold)
                                Text("Score: \(gameViewModel.score)")
                                    .font(.system(size: 44))
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                        
                        GeometryReader { geo in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .frame(height: 10)
                                    .foregroundColor(.red)
                                Rectangle()
                                    .frame(width: (health / maxHealth) * geo.size.width, height: 10)
                                    .foregroundColor(.green)
                            }
                            .cornerRadius(5)
                        }
                        .frame(height: 10)
                        
                        Spacer()
                    }
                    .padding(20)
                    .padding(.top, UIScreen.main.bounds.height / 10)
                    
                    ForEach($fallingObjects) { $object in
                        FallingObjectView(object: $object, laneWidth: laneWidth, objectSize: objectSize, lanesCount: lanesCount)
                    }
                }
                .onAppear {
                    for index in fallingObjects.indices {
                        fallingObjects[index].yPosition = -objectSize / 2 - CGFloat(index) * 200
                        let correct = correctLane(for: fallingObjects[index].type)
                        if fallingObjects[index].lane == correct {
                            fallingObjects[index].lane = randomLane(excluding: correct)
                        }
                    }
                }
                .onReceive(Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()) { _ in
                    guard health > 0, !gameViewModel.showPopupPause else { return }
                    for index in fallingObjects.indices {
                        fallingObjects[index].yPosition += fallingSpeed
                        if fallingObjects[index].yPosition + objectSize / 2 >= screenHeight - binsHeight {
                            let correct = correctLane(for: fallingObjects[index].type)
                            if fallingObjects[index].lane == correct {
                                triggerPlusOne(for: correct)
                                gameViewModel.score += 1
                                if gameViewModel.score > gameViewModel.highScore {
                                    gameViewModel.highScore = gameViewModel.score
                                }
                                soundManager.playCorrectSound()
                            } else {
                                health = max(health - 10, 0)
                                triggerWrong(for: fallingObjects[index].lane)
                                if health == 0 {
                                    gameViewModel.showPopupGameOver = true
                                }
                                soundManager.playIncorrectSound()
                            }
                            fallingObjects[index].yPosition = -objectSize / 2
                            let newType = FallingObjectType.allCases.randomElement()!
                            fallingObjects[index].type = newType
                            fallingObjects[index].imageName = newType.imageNames.randomElement()!
                            fallingObjects[index].lane = randomLane(excluding: correctLane(for: newType))
                        }
                    }
                }
            }
            
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<lanesCount, id: \.self) { lane in
                        ZStack {
                            Image(binImages[lane])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width / 4.2)
                            if showPlusOne[lane] {
                                Text("+1")
                                    .font(.system(size: 50))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                    .animation(.easeOut(duration: 0.5), value: showPlusOne[lane])
                                    .offset(y: -60)
                            }
                            if showWrong[lane] {
                                Text("X")
                                    .font(.system(size: 50))
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
                                    .transition(.move(edge: .top).combined(with: .opacity))
                                    .animation(.easeOut(duration: 0.5), value: showWrong[lane])
                                    .offset(y: -60)
                            }
                        }
                    }
                }
                .padding(.bottom, UIScreen.main.bounds.height / 40)
            }
            
            if gameViewModel.showPopupPause {
                PauseValidationView()
            }
            if gameViewModel.showPopupGameOver {
                GameOverView(onRestart: resetGame)
            }
        }
        .onAppear {
            soundManager.playBackgroundMusic()
        }
        .onChange(of: gameViewModel.showPopupPause) { isPaused in
            if isPaused {
                soundManager.stopBackgroundMusic()
            } else if soundManager.isSoundOn {
                soundManager.playBackgroundMusic()
            }
        }
        .onChange(of: gameViewModel.showPopupGameOver) { isGameOver in
            if isGameOver {
                soundManager.stopBackgroundMusic()
            } else if soundManager.isSoundOn {
                soundManager.playBackgroundMusic()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GameView()
        .environmentObject(GameViewModel())
        .environmentObject(SoundManager())
}
