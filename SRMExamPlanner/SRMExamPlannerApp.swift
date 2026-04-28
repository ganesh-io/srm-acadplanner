import SwiftUI

@main
struct SRMExamPlannerApp: App {
    @StateObject private var habitStore = HabitStore()
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(habitStore)
                .preferredColorScheme(.dark)
        }
    }
}
