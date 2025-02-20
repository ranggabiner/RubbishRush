//
//  GameView.swift
//  RubbishRush
//
//  Created by Rangga Biner on 20/02/25.
//

import SwiftUI

// MARK: - Falling Object Types & Model

/// Enum untuk jenis objek jatuh dengan 4 varian.
enum FallingObjectType: CaseIterable {
    case type1, type2, type3, type4
}

/// Ekstensi untuk menyediakan deskripsi teks untuk tiap jenis.
extension FallingObjectType {
    var description: String {
        switch self {
        case .type1: return "Type 1"
        case .type2: return "Type 2"
        case .type3: return "Type 3"
        case .type4: return "Type 4"
        }
    }
}

/// Model yang merepresentasikan objek jatuh.
struct FallingObject: Identifiable {
    let id = UUID()              // Identifier unik
    var lane: Int                // Indeks lane (0 sampai lanesCount-1)
    var yPosition: CGFloat       // Posisi vertikal di layar
    var type: FallingObjectType  // Jenis objek
}

// MARK: - GameView

/// Tampilan utama game yang mengintegrasikan background, objek jatuh, bins, dan overlay kontrol.
struct GameView: View {
    @EnvironmentObject var gameViewModel: GameViewModel  // State game eksternal
    
    // Konfigurasi game
    let lanesCount: Int = 4         // Jumlah lane/kolom
    let objectSize: CGFloat = 100   // Diameter objek jatuh
    let fallingSpeed: CGFloat = 3   // Kecepatan jatuh objek
    let maxHealth: CGFloat = 100    // Health maksimal
    
    // Variabel state untuk objek jatuh, skor, dan health
    @State private var fallingObjects: [FallingObject] = [
        FallingObject(lane: 0, yPosition: -100, type: .type1),
        FallingObject(lane: 1, yPosition: -300, type: .type2),
        FallingObject(lane: 2, yPosition: -500, type: .type3),
        FallingObject(lane: 3, yPosition: -700, type: .type4)
    ]
    @State private var score: Int = 0
    @State private var health: CGFloat = 100  // Health awal
    
    // MARK: - Helper Functions
    
    /// Mengembalikan warna berdasarkan jenis objek.
    private func colorForObjectType(_ type: FallingObjectType) -> Color {
        switch type {
        case .type1: return .green
        case .type2: return .red
        case .type3: return .blue
        case .type4: return .yellow
        }
    }
    
    /// Menentukan lane yang tepat untuk suatu jenis objek (pemetaan: type1 → lane 0, dll).
    private func correctLane(for type: FallingObjectType) -> Int {
        if let index = FallingObjectType.allCases.firstIndex(of: type) {
            return index
        }
        return 0
    }
    
    /// Mengembalikan lane acak, kecuali lane yang dikecualikan.
    private func randomLane(excluding excludedLane: Int) -> Int {
        var availableLanes = Array(0..<lanesCount)
        availableLanes.removeAll { $0 == excludedLane }
        return availableLanes.randomElement()!
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
                // Konstanta untuk mendefinisikan tinggi area bins (disesuaikan jika perlu)
                let binsHeight: CGFloat = 120
                
                ZStack {
                    // Tampilan skor dan health indicator di bagian atas.
                    VStack(spacing: 10) {
                        Text("Score: \(score)")
                            .font(.largeTitle)
                        
                        // Health indicator horizontal
                        HStack {
                            Text("Health")
                                .font(.caption)
                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    // Latar belakang health bar
                                    Rectangle()
                                        .frame(height: 10)
                                        .foregroundColor(Color.gray.opacity(0.3))
                                    // Bar health yang menunjukkan sisa health
                                    Rectangle()
                                        .frame(width: (health / maxHealth) * geo.size.width, height: 10)
                                        .foregroundColor(.green)
                                }
                                .cornerRadius(5)
                            }
                            .frame(height: 10)
                        }
                        .padding(.horizontal, 20)
                        
                        Spacer()
                    }
                    .padding(.top, 100)
                    
                    // Gambar pembagi lane dan label lane.
                    ForEach(0..<lanesCount, id: \.self) { index in
                        // Garis pembagi lane.
                        Path { path in
                            let xPosition = laneWidth * CGFloat(index)
                            path.move(to: CGPoint(x: xPosition, y: 0))
                            path.addLine(to: CGPoint(x: xPosition, y: screenHeight))
                        }
                        .stroke(Color.gray, lineWidth: 1)
                        
                        // Label lane (hanya jika index valid untuk tipe objek).
                        if index < FallingObjectType.allCases.count {
                            let laneType = FallingObjectType.allCases[index]
                            Text(laneType.description)
                                .font(.caption)
                                .foregroundColor(colorForObjectType(laneType))
                                .position(x: laneWidth * (CGFloat(index) + 0.5), y: 20)
                        }
                    }
                    
                    // Render setiap objek jatuh.
                    ForEach($fallingObjects) { $object in
                        Circle()
                            .fill(colorForObjectType(object.type))
                            .frame(width: objectSize, height: objectSize)
                            .position(x: laneWidth * (CGFloat(object.lane) + 0.5), y: object.yPosition)
                            // Gesture swipe untuk mengubah lane.
                            .gesture(
                                DragGesture(minimumDistance: 20)
                                    .onEnded { value in
                                        if value.translation.width < -30, object.lane > 0 {
                                            object.lane -= 1  // Swipe ke kiri.
                                        } else if value.translation.width > 30, object.lane < lanesCount - 1 {
                                            object.lane += 1  // Swipe ke kanan.
                                        }
                                    }
                            )
                    }
                }
                // Inisialisasi posisi awal objek jatuh.
                .onAppear {
                    for index in fallingObjects.indices {
                        fallingObjects[index].yPosition = -objectSize / 2 - CGFloat(index) * 200
                        let correct = correctLane(for: fallingObjects[index].type)
                        // Pastikan lane awal bukan lane yang benar.
                        if fallingObjects[index].lane == correct {
                            fallingObjects[index].lane = randomLane(excluding: correct)
                        }
                    }
                }
                // Timer untuk mengupdate posisi objek jatuh.
                .onReceive(Timer.publish(every: 0.02, on: .main, in: .common).autoconnect()) { _ in
                    // Hentikan update game ketika health habis
                    guard health > 0 else { return }
                    
                    for index in fallingObjects.indices {
                        fallingObjects[index].yPosition += fallingSpeed
                        
                        // Cek jika objek telah menyentuh area bins di bagian bawah.
                        if fallingObjects[index].yPosition + objectSize / 2 >= screenHeight - binsHeight {
                            let correct = correctLane(for: fallingObjects[index].type)
                            // Jika objek berada pada lane yang tepat, tambah skor.
                            if fallingObjects[index].lane == correct {
                                score += 1
                            } else {
                                // Jika tidak tepat, kurangi health.
                                health = max(health - 10, 0)
                                // Tampilkan popup game over ketika health habis.
                                if health == 0 {
                                    gameViewModel.showPopupBack = true
                                }
                            }
                            
                            // Reset objek ke atas dengan tipe baru dan lane acak (kecuali lane yang benar).
                            fallingObjects[index].yPosition = -objectSize / 2
                            fallingObjects[index].type = FallingObjectType.allCases.randomElement()!
                            fallingObjects[index].lane = randomLane(excluding: correctLane(for: fallingObjects[index].type))
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
            
            // Overlay atas dengan tombol back dan pause.
            VStack {
                HStack {
                    Button(action: { gameViewModel.showPopupBack = true }) {
                        Image(systemName: "arrowshape.backward.circle")
                            .foregroundStyle(.black)
                            .font(.system(size: 42))
                    }
                    Spacer()
                    Button(action: { gameViewModel.showPopupPause = true }) {
                        Image(systemName: "pause.circle")
                            .foregroundStyle(.black)
                            .font(.system(size: 42))
                    }
                }
                .padding(.horizontal, 28)
                .padding(.top, 48)
                Spacer()
            }
            
            // Pop-up validasi untuk back dan pause.
            if gameViewModel.showPopupBack {
                BackValidationView()
            }
            if gameViewModel.showPopupPause {
                PauseValidationView()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView().environmentObject(GameViewModel())
    }
}
