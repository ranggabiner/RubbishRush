import SwiftUI

@main
struct MyApp: App {
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var gameViewModel = GameViewModel()
    @StateObject private var backValidationViewModel = BackValidationViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(homeViewModel) 
                .environmentObject(gameViewModel)
                .environmentObject(backValidationViewModel)
        }
    }
}
