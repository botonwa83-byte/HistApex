import SwiftUI

@main
struct HistApexApp: App {
    @StateObject private var progress = ProgressManager.shared
    @StateObject private var appearance = AppearanceManager.shared

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(progress)
                .preferredColorScheme(appearance.colorScheme)
        }
    }
}
