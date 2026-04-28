import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            AppTheme.background
                .ignoresSafeArea()
            
            // Tab content
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .subjects:
                    SubjectsView()
                case .planner:
                    PlannerView()
                case .habits:
                    HabitsView()
                case .profile:
                    ProfileView()
                }
            }
            
            // Floating tab bar
            CustomTabBar(selectedTab: $selectedTab)
        }
    }
}
