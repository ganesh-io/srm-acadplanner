import SwiftUI

enum TabItem: Int, CaseIterable {
    case home, subjects, planner, habits, profile
    
    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .subjects: return "book.fill"
        case .planner: return "calendar"
        case .habits: return "checkmark.circle.fill"
        case .profile: return "person.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .subjects: return "Subjects"
        case .planner: return "Planner"
        case .habits: return "Habits"
        case .profile: return "Profile"
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabBarButton(tab: tab, isSelected: selectedTab == tab, animation: animation)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            selectedTab = tab
                        }
                    }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color(hex: "1A1733").opacity(0.75))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.4), radius: 20, y: 10)
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 8)
    }
}

private struct TabBarButton: View {
    let tab: TabItem
    let isSelected: Bool
    let animation: Namespace.ID
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                if isSelected {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(AppTheme.primaryGradient)
                        .frame(width: 48, height: 32)
                        .matchedGeometryEffect(id: "tabIndicator", in: animation)
                        .shadow(color: AppTheme.primary.opacity(0.5), radius: 8, y: 2)
                }
                
                Image(systemName: tab.icon)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(isSelected ? .white : AppTheme.textTertiary)
            }
            .frame(height: 32)
            
            Text(tab.title)
                .font(.system(size: 10, weight: isSelected ? .bold : .medium))
                .foregroundColor(isSelected ? AppTheme.textPrimary : AppTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}
