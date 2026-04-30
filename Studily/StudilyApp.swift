import SwiftUI

@main
struct StudilyApp: App {
    @StateObject private var habitStore = HabitStore()
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        // Request notification permission on first launch
        NotificationHelper.requestPermission()
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(habitStore)
                .preferredColorScheme(.dark)
                .onChange(of: scenePhase) { _, newPhase in
                    if newPhase == .active {
                        // Check midnight reset when app comes to foreground
                        habitStore.checkMidnightReset()
                    }
                }
        }
    }
}
