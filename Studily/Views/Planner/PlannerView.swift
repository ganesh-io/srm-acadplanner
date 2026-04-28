import SwiftUI

struct PlannerView: View {
    let exams = Exam.sampleExams
    @State private var selectedDate = Date()
    
    private var todaysSessions: [(String, String, String, String)] {
        [
            ("Engineering Mathematics", "Differential Equations", "9:00 AM – 10:30 AM", "6366F1"),
            ("Data Structures", "Binary Trees & Heaps", "11:00 AM – 12:30 PM", "8B5CF6"),
            ("Digital Electronics", "K-Maps & Minimization", "2:00 PM – 3:00 PM", "06B6D4"),
            ("Operating Systems", "Process Scheduling", "4:00 PM – 5:30 PM", "F43F5E"),
            ("Computer Networks", "TCP/IP Protocols", "7:00 PM – 8:00 PM", "F97316"),
        ]
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("STUDY PLANNER")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundColor(AppTheme.textTertiary)
                        Text("Today's Plan")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    Spacer()
                    
                    // Date badge
                    VStack(spacing: 2) {
                        Text(dayOfWeek)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(AppTheme.primary)
                        Text(dayNumber)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    .frame(width: 52, height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(.ultraThinMaterial)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(AppTheme.cardBackground)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(AppTheme.primary.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
                .padding(.top, 16)
                
                // Weekly calendar strip
                weekCalendarStrip
                
                // Study hours summary
                GlassCard {
                    HStack(spacing: 20) {
                        StudySummaryItem(icon: "clock.fill", value: "6.5h", label: "Study Time", gradient: AppTheme.primaryGradient)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.06))
                            .frame(width: 1, height: 40)
                        
                        StudySummaryItem(icon: "target", value: "5", label: "Sessions", gradient: AppTheme.coolGradient)
                        
                        Rectangle()
                            .fill(Color.white.opacity(0.06))
                            .frame(width: 1, height: 40)
                        
                        StudySummaryItem(icon: "flame.fill", value: "3", label: "Streak", gradient: AppTheme.accentGradient)
                    }
                    .frame(maxWidth: .infinity)
                }
                
                // Sessions Header
                HStack {
                    Text("Study Sessions")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textPrimary)
                    Spacer()
                    Text("\(todaysSessions.count) sessions")
                        .font(.caption)
                        .foregroundColor(AppTheme.textTertiary)
                }
                
                // Session Timeline
                VStack(spacing: 0) {
                    ForEach(Array(todaysSessions.enumerated()), id: \.offset) { index, session in
                        SessionTimelineItem(
                            subject: session.0,
                            topic: session.1,
                            time: session.2,
                            color: session.3,
                            isLast: index == todaysSessions.count - 1,
                            delay: Double(index) * 0.1
                        )
                    }
                }
                
                // Exam schedule
                VStack(alignment: .leading, spacing: 12) {
                    Text("Exam Schedule")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(AppTheme.textPrimary)
                    
                    ForEach(exams.filter { !$0.isPast }) { exam in
                        ExamCard(exam: exam)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background)
    }
    
    // MARK: - Week Calendar Strip
    private var weekCalendarStrip: some View {
        let calendar = Calendar.current
        let today = Date()
        let weekDays: [Date] = (-3...3).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: today)
        }
        
        return HStack(spacing: 8) {
            ForEach(weekDays, id: \.self) { date in
                let isToday = calendar.isDateInToday(date)
                VStack(spacing: 6) {
                    Text(shortWeekday(date))
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(isToday ? .white : AppTheme.textTertiary)
                    Text("\(calendar.component(.day, from: date))")
                        .font(.system(size: 14, weight: isToday ? .bold : .medium, design: .rounded))
                        .foregroundColor(isToday ? .white : AppTheme.textSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    Group {
                        if isToday {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(AppTheme.primaryGradient)
                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.clear)
                        }
                    }
                )
            }
        }
    }
    
    private var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: Date()).uppercased()
    }
    
    private var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: Date())
    }
    
    private func shortWeekday(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date).prefix(3).uppercased()
    }
}

private struct StudySummaryItem: View {
    let icon: String
    let value: String
    let label: String
    let gradient: LinearGradient
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundStyle(gradient)
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .rounded))
                .foregroundColor(AppTheme.textPrimary)
            Text(label)
                .font(.system(size: 9, weight: .medium))
                .foregroundColor(AppTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct SessionTimelineItem: View {
    let subject: String
    let topic: String
    let time: String
    let color: String
    let isLast: Bool
    let delay: Double
    
    @State private var appear = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            // Timeline dot + line
            VStack(spacing: 0) {
                Circle()
                    .fill(Color(hex: color))
                    .frame(width: 12, height: 12)
                    .shadow(color: Color(hex: color).opacity(0.5), radius: 4)
                
                if !isLast {
                    Rectangle()
                        .fill(Color(hex: color).opacity(0.2))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 12)
            
            // Content card
            GlassCard(padding: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(subject)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.textPrimary)
                    Text(topic)
                        .font(.caption)
                        .foregroundColor(AppTheme.textSecondary)
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 10))
                        Text(time)
                            .font(.caption2)
                    }
                    .foregroundColor(Color(hex: color))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.bottom, isLast ? 0 : 4)
        .opacity(appear ? 1 : 0)
        .offset(x: appear ? 0 : -20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                appear = true
            }
        }
    }
}
