import SwiftUI

struct HabitsView: View {
    @EnvironmentObject var habitStore: HabitStore
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("DAILY HABITS")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundColor(AppTheme.textTertiary)
                        Text("Stay Consistent")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    Spacer()
                }
                .padding(.top, 16)
                
                // Circular Progress Ring
                ZStack {
                    CircularProgressRing(
                        progress: habitStore.completionPercentage,
                        size: 180,
                        lineWidth: 14,
                        gradient: habitStore.completionPercentage == 1.0
                            ? AppTheme.successGradient
                            : AppTheme.primaryGradient
                    )
                    
                    VStack(spacing: 4) {
                        Text("\(Int(habitStore.completionPercentage * 100))%")
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                habitStore.completionPercentage == 1.0
                                    ? AppTheme.successGradient
                                    : AppTheme.primaryGradient
                            )
                        Text("\(habitStore.completedCount) of \(habitStore.totalCount)")
                            .font(.caption)
                            .foregroundColor(AppTheme.textTertiary)
                    }
                }
                .padding(.vertical, 8)
                
                // Motivation text
                GlassCard {
                    HStack(spacing: 12) {
                        Image(systemName: motivationIcon)
                            .font(.title2)
                            .foregroundStyle(motivationGradient)
                        
                        Text(motivationText)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Habit toggles
                VStack(spacing: 10) {
                    ForEach(Array(habitStore.habits.enumerated()), id: \.element.id) { index, habit in
                        HabitToggleRow(
                            habit: habit,
                            delay: Double(index) * 0.06,
                            onToggle: {
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    habitStore.toggleHabit(habit)
                                }
                            }
                        )
                    }
                }
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background)
    }
    
    private var motivationText: String {
        let pct = habitStore.completionPercentage
        switch pct {
        case 1.0: return "Perfect day! All habits completed! 🏆"
        case 0.75..<1.0: return "Almost there! Keep pushing! 💪"
        case 0.5..<0.75: return "Great progress! Stay focused! 🔥"
        case 0.25..<0.5: return "Good start! Keep going! ⚡"
        default: return "Let's build momentum today! 🚀"
        }
    }
    
    private var motivationIcon: String {
        let pct = habitStore.completionPercentage
        switch pct {
        case 1.0: return "trophy.fill"
        case 0.75..<1.0: return "flame.fill"
        case 0.5..<0.75: return "bolt.fill"
        default: return "sparkles"
        }
    }
    
    private var motivationGradient: LinearGradient {
        let pct = habitStore.completionPercentage
        switch pct {
        case 1.0: return AppTheme.successGradient
        case 0.75..<1.0: return AppTheme.accentGradient
        case 0.5..<0.75: return AppTheme.warmGradient
        default: return AppTheme.primaryGradient
        }
    }
}

private struct HabitToggleRow: View {
    let habit: Habit
    let delay: Double
    let onToggle: () -> Void
    
    @State private var appear = false
    
    var body: some View {
        Button(action: onToggle) {
            GlassCard(padding: 14) {
                HStack(spacing: 14) {
                    // Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: habit.color).opacity(habit.isCompleted ? 0.25 : 0.12))
                            .frame(width: 44, height: 44)
                        Image(systemName: habit.icon)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color(hex: habit.color))
                    }
                    
                    // Name
                    Text(habit.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(
                            habit.isCompleted ? AppTheme.textSecondary : AppTheme.textPrimary
                        )
                        .strikethrough(habit.isCompleted, color: AppTheme.textTertiary)
                    
                    Spacer()
                    
                    // Toggle checkmark
                    ZStack {
                        Group {
                            if habit.isCompleted {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(LinearGradient(
                                        colors: [Color(hex: habit.color), Color(hex: habit.color).opacity(0.7)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing))
                                    .frame(width: 36, height: 36)
                            } else {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.06))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(Color.white.opacity(0.12), lineWidth: 1.5)
                                    )
                            }
                        }
                        
                        if habit.isCompleted {
                            Image(systemName: "checkmark")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .shadow(
                        color: habit.isCompleted ? Color(hex: habit.color).opacity(0.4) : .clear,
                        radius: 6
                    )
                }
            }
        }
        .buttonStyle(.plain)
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 15)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay)) {
                appear = true
            }
        }
    }
}
