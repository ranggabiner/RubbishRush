import SwiftUI

@main
struct MyApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var gameViewModel = GameViewModel()
    @StateObject private var pauseValidationViewModel = PauseValidationViewModel()
    @StateObject private var gameOverValidationViewModel = GameOverValidationViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(homeViewModel) 
                .environmentObject(gameViewModel)
                .environmentObject(pauseValidationViewModel)
                .environmentObject(gameOverValidationViewModel)
        }
    }
}
