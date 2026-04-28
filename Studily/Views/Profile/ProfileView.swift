import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var habitStore: HabitStore
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = true
    @State private var studyReminders = true
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("PROFILE")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundColor(AppTheme.textTertiary)
                        Text("Settings")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    Spacer()
                }
                .padding(.top, 16)
                
                // Avatar Section
                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(AppTheme.primaryGradient)
                            .frame(width: 80, height: 80)
                        Text("S")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                    }
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [Color.white.opacity(0.3), Color.white.opacity(0.05)],
                                    startPoint: .topLeading, endPoint: .bottomTrailing
                                ), lineWidth: 3
                            )
                    )
                    .shadow(color: AppTheme.primary.opacity(0.3), radius: 16)
                    
                    Text("SRM Student")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textPrimary)
                    Text("B.Tech Computer Science & Engineering")
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                }
                
                // Quick Stats
                HStack(spacing: 12) {
                    ProfileStatBadge(value: "\(DateHelper.daysUntilExam)", label: "Days Left",
                                     icon: "calendar", gradient: AppTheme.accentGradient)
                    ProfileStatBadge(value: "8.4", label: "CGPA",
                                     icon: "star.fill", gradient: AppTheme.warmGradient)
                    ProfileStatBadge(value: "\(habitStore.completedCount)", label: "Habits Done",
                                     icon: "checkmark.circle", gradient: AppTheme.successGradient)
                }
                
                // Settings Sections
                VStack(spacing: 12) {
                    SectionHeader(title: "Preferences")
                    
                    ToggleSettingRow(
                        icon: "bell.fill", color: "8B5CF6",
                        title: "Notifications", isOn: $notificationsEnabled
                    )
                    ToggleSettingRow(
                        icon: "moon.fill", color: "6366F1",
                        title: "Dark Mode", isOn: $darkModeEnabled
                    )
                    ToggleSettingRow(
                        icon: "clock.fill", color: "F97316",
                        title: "Study Reminders", isOn: $studyReminders
                    )
                }
                
                VStack(spacing: 12) {
                    SectionHeader(title: "Academic")
                    
                    InfoSettingRow(icon: "building.2.fill", color: "06B6D4",
                                   title: "Department", value: "CSE")
                    InfoSettingRow(icon: "graduationcap.fill", color: "10B981",
                                   title: "Year", value: "3rd Year")
                    InfoSettingRow(icon: "mappin.circle.fill", color: "F43F5E",
                                   title: "Campus", value: "Kattankulathur")
                }
                
                VStack(spacing: 12) {
                    SectionHeader(title: "About")
                    
                    InfoSettingRow(icon: "info.circle.fill", color: "818CF8",
                                   title: "Version", value: "1.0.0")
                    InfoSettingRow(icon: "swift", color: "F97316",
                                   title: "Built with", value: "SwiftUI")
                }
                
                // App branding
                VStack(spacing: 6) {
                    Text("Studily")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(AppTheme.primaryGradient)
                    Text("Made for SRM Students")
                        .font(.caption2)
                        .foregroundColor(AppTheme.textTertiary)
                }
                .padding(.top, 12)
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background)
    }
}

// MARK: - Sub-components

private struct ProfileStatBadge: View {
    let value: String
    let label: String
    let icon: String
    let gradient: LinearGradient
    
    var body: some View {
        GlassCard(padding: 14) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundStyle(gradient)
                Text(value)
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
                Text(label)
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(AppTheme.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private struct SectionHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .tracking(1.5)
                .foregroundColor(AppTheme.textTertiary)
            Spacer()
        }
        .padding(.top, 4)
    }
}

private struct ToggleSettingRow: View {
    let icon: String
    let color: String
    let title: String
    @Binding var isOn: Bool
    
    var body: some View {
        GlassCard(padding: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: color).opacity(0.15))
                        .frame(width: 38, height: 38)
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: color))
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Toggle("", isOn: $isOn)
                    .tint(Color(hex: color))
                    .labelsHidden()
            }
        }
    }
}

private struct InfoSettingRow: View {
    let icon: String
    let color: String
    let title: String
    let value: String
    
    var body: some View {
        GlassCard(padding: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: color).opacity(0.15))
                        .frame(width: 38, height: 38)
                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(Color(hex: color))
                }
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(AppTheme.textPrimary)
                
                Spacer()
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
            }
        }
    }
}
