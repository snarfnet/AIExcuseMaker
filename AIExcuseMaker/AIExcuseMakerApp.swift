import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

@main
struct AIExcuseMakerApp: App {
    @StateObject private var historyManager = HistoryManager()

    init() {
        MobileAds.shared.start(completionHandler: nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(historyManager)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        ATTrackingManager.requestTrackingAuthorization { _ in }
                    }
                }
        }
    }
}
