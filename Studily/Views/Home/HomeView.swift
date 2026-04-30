import SwiftUI

struct HomeView: View {
    @EnvironmentObject var habitStore: HabitStore
    @State private var showProfile = false
    @State private var appear = false
    
    private let exams = Exam.sampleExams
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                headerSection
                ExamCountdownCard()
                    .environmentObject(habitStore)
                quickStatsSection
                upcomingExamsSection
                habitsPreviewSection
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.top, 8)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background)
        .sheet(isPresented: $showProfile) {
            ProfileSheetView()
        }
    }
    
    // MARK: - Header
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Good \(greetingTime) 👋")
                    .font(.subheadline)
                    .foregroundColor(AppTheme.textSecondary)
                Text("Studily")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
            }
            
            Spacer()
            
            Button {
                showProfile = true
            } label: {
                ZStack {
                    Circle()
                        .fill(AppTheme.primaryGradient)
                        .frame(width: 44, height: 44)
                    Text("S")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                }
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.15), lineWidth: 2)
                )
            }
        }
        .padding(.top, 8)
    }
    
    // MARK: - Quick Stats
    private var quickStatsSection: some View {
        HStack(spacing: 12) {
            StatCard(
                icon: "calendar.badge.clock",
                value: DateHelper.daysUntilExam.map { "\($0)" } ?? "—",
                label: "Days Left",
                gradient: AppTheme.accentGradient
            )
            StatCard(
                icon: "book.closed.fill",
                value: "\(habitStore.subjects.count)",
                label: "Subjects",
                gradient: AppTheme.primaryGradient
            )
            StatCard(
                icon: "checkmark.circle.fill",
                value: "\(habitStore.completedCount)/\(habitStore.totalCount)",
                label: "Habits",
                gradient: AppTheme.successGradient
            )
        }
    }
    
    // MARK: - Upcoming Exams
    private var upcomingExamsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Upcoming Exams")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text("\(exams.filter { !$0.isPast }.count) remaining")
                    .font(.caption)
                    .foregroundColor(AppTheme.textTertiary)
            }
            
            ForEach(exams.filter { !$0.isPast }.prefix(4)) { exam in
                ExamCard(exam: exam)
            }
        }
    }
    
    // MARK: - Habits Preview
    private var habitsPreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Habits")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(AppTheme.textPrimary)
                Spacer()
                Text("\(Int(habitStore.completionPercentage * 100))%")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.primaryGradient)
            }
            
            AnimatedProgressBar(
                progress: habitStore.completionPercentage,
                height: 10,
                gradient: AppTheme.primaryGradient
            )
        }
    }
    
    private var greetingTime: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Morning"
        case 12..<17: return "Afternoon"
        case 17..<21: return "Evening"
        default: return "Night"
        }
    }
}

// MARK: - Stat Card
private struct StatCard: View {
    let icon: String
    let value: String
    let label: String
    let gradient: LinearGradient
    @State private var appear = false
    
    var body: some View {
        GlassCard(padding: 14) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundStyle(gradient)
                
                Text(value)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(AppTheme.textPrimary)
                
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(AppTheme.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
        .scaleEffect(appear ? 1.0 : 0.85)
        .opacity(appear ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.15)) {
                appear = true
            }
        }
    }
}
