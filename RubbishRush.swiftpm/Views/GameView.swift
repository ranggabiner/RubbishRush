//
//  GameView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import SwiftUI
import AVFoundation

// MARK: - SoundManager
/// Mengelola pemutaran musik latar dan toggle suara.
class SoundManager: ObservableObject {
    @Published var isSoundOn: Bool = true  // Status suara aktif/tidak
    var audioPlayer: AVAudioPlayer?
    
    /// Memulai pemutaran musik latar secara looping.
    func playBackgroundMusic() {
        // Hanya putar jika suara aktif dan file musik tersedia.
        guard isSoundOn,
              let url = Bundle.main.url(forResource: "guitar", withExtension: "mp3") else {
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1  // Loop tak terhingga
            audioPlayer?.play()
        } catch {
            print("Error saat memainkan musik: \(error.localizedDescription)")
        }
    }
    
    /// Menghentikan musik latar.
    func stopBackgroundMusic() {
        audioPlayer?.stop()
    }
    
    /// Mengubah status suara.
    func toggleSound() {
        isSoundOn.toggle()
        if isSoundOn {
            playBackgroundMusic()
        } else {
            stopBackgroundMusic()
        }
    }
}

// MARK: - Falling Object Types & Model

/// Enum untuk jenis objek jatuh dengan 4 varian.
enum FallingObjectType: CaseIterable {
    case type1, type2, type3, type4
}

/// Ekstensi untuk menyediakan deskripsi dan daftar nama gambar tiap tipe.
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

// MARK: - GameView
/// Tampilan utama game yang mengintegrasikan background, objek jatuh, bins, dan overlay kontrol.
struct GameView: View {
    @EnvironmentObject var gameViewModel: GameViewModel  // State game eksternal
    @EnvironmentObject var soundManager: SoundManager    // Manajemen suara
    
    // Konfigurasi game.
    let lanesCount: Int = 4         // Jumlah lane/kolom
    let objectSize: CGFloat = UIScreen.main.bounds.width / 8   // Ukuran objek jatuh
    let fallingSpeed: CGFloat = 3   // Kecepatan jatuh objek
    let maxHealth: CGFloat = 100    // Health maksimal
    
    // Variabel state untuk objek jatuh, skor, dan health.
    @State private var fallingObjects: [FallingObject] = [
        FallingObject(lane: 0, yPosition: -100, type: .type1),
        FallingObject(lane: 1, yPosition: -300, type: .type2),
        FallingObject(lane: 2, yPosition: -500, type: .type3),
        FallingObject(lane: 3, yPosition: -700, type: .type4)
    ]
    @State private var health: CGFloat = 100  // Health awal
    
    // MARK: - Helper Functions
    
    /// Mengembalikan lane yang tepat untuk suatu jenis objek.
    private func correctLane(for type: FallingObjectType) -> Int {
        FallingObjectType.allCases.firstIndex(of: type) ?? 0
    }
    
    /// Mengembalikan lane acak, kecuali lane yang dikecualikan.
    private func randomLane(excluding excludedLane: Int) -> Int {
        var availableLanes = Array(0..<lanesCount)
        availableLanes.removeAll { $0 == excludedLane }
        return availableLanes.randomElement()!
    }
    
    /// Fungsi untuk mereset game ke kondisi awal.
    private func resetGame() {
        gameViewModel.score = 0                      // Reset skor ke 0
        health = maxHealth                           // Reset health ke 100
        
        // Reset posisi awal objek jatuh.
        for index in fallingObjects.indices {
            fallingObjects[index].yPosition = -objectSize / 2 - CGFloat(index) * 200
            let correct = correctLane(for: fallingObjects[index].type)
            // Pastikan lane awal tidak sama dengan lane yang benar.
            fallingObjects[index].lane = randomLane(excluding: correct)
        }
        
        // Sembunyikan popup game over.
        gameViewModel.showPopupGameOver = false
    }
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background game.
            Image("GameBackground")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // Layer objek jatuh, divider lane, dan label skor.
            GeometryReader { geometry in
                let laneWidth = geometry.size.width / CGFloat(lanesCount)
                let screenHeight = geometry.size.height
                let binsHeight: CGFloat = 120  // Tinggi area bins
                
                ZStack {
                    // Tampilan skor dan health indicator.
                    VStack(spacing: 10) {
                        // Overlay kontrol: tombol pause dan tombol toggle suara.
                        HStack {
                            // Tombol toggle suara (diletakkan di kiri atas).
                            Button(action: {
                                soundManager.toggleSound()
                            }) {
                                Image(systemName: soundManager.isSoundOn ? "speaker.wave.2.fill" : "speaker.slash.fill")
                                    .font(.system(size: 32))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                            // Tombol pause (diletakkan di kanan atas).
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
                        
                        // Health indicator.
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
                    
                    // Render setiap objek jatuh.
                    ForEach($fallingObjects) { $object in
                        FallingObjectView(object: $object, laneWidth: laneWidth, objectSize: objectSize, lanesCount: lanesCount)
                    }
                }
                .onAppear {
                    // Inisialisasi posisi objek jatuh.
                    for index in fallingObjects.indices {
                        fallingObjects[index].yPosition = -objectSize / 2 - CGFloat(index) * 200
                        let correct = correctLane(for: fallingObjects[index].type)
                        if fallingObjects[index].lane == correct {
                            fallingObjects[index].lane = randomLane(excluding: correct)
                        }
                    }
                }
                // Timer untuk mengupdate posisi objek jatuh.
                .onReceive(Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()) { _ in
                    // Hentikan update objek jika game dalam keadaan pause atau health habis.
                    guard health > 0, !gameViewModel.showPopupPause else { return }
                    for index in fallingObjects.indices {
                        fallingObjects[index].yPosition += fallingSpeed
                        if fallingObjects[index].yPosition + objectSize / 2 >= screenHeight - binsHeight {
                            let correct = correctLane(for: fallingObjects[index].type)
                            if fallingObjects[index].lane == correct {
                                gameViewModel.score += 1
                                if gameViewModel.score > gameViewModel.highScore {
                                    gameViewModel.highScore = gameViewModel.score
                                }
                            } else {
                                health = max(health - 10, 0)
                                if health == 0 {
                                    gameViewModel.showPopupGameOver = true
                                }
                            }
                            // Reset objek jatuh.
                            fallingObjects[index].yPosition = -objectSize / 2
                            let newType = FallingObjectType.allCases.randomElement()!
                            fallingObjects[index].type = newType
                            fallingObjects[index].imageName = newType.imageNames.randomElement()!
                            fallingObjects[index].lane = randomLane(excluding: correctLane(for: newType))
                        }
                    }
                }
            }
            
            // Tampilan bins di bagian bawah layar.
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
            
            // Tampilkan popup pause dan game over tanpa memicu side effect di dalam body.
            if gameViewModel.showPopupPause {
                PauseValidationView()
            }
            if gameViewModel.showPopupGameOver {
                GameOverView(onRestart: resetGame)
            }
        }
        // Mulai musik latar saat tampilan muncul.
        .onAppear {
            soundManager.playBackgroundMusic()
        }
        // Gunakan onChange untuk menghentikan atau memulai musik berdasarkan status popup.
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

// MARK: - Preview
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(GameViewModel())
            .environmentObject(SoundManager())
    }
}
