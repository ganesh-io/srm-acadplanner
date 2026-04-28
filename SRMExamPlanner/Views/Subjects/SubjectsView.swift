import SwiftUI

struct SubjectsView: View {
    let subjects = Subject.sampleSubjects
    
    private var overallProgress: Double {
        guard !subjects.isEmpty else { return 0 }
        return subjects.reduce(0) { $0 + $1.progress } / Double(subjects.count)
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("SUBJECTS")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundColor(AppTheme.textTertiary)
                        Text("Your Progress")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    Spacer()
                }
                .padding(.top, 16)
                
                // Overall Progress Card
                GlassCard {
                    VStack(spacing: 14) {
                        HStack {
                            Text("Overall Completion")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.textSecondary)
                            Spacer()
                            Text("\(Int(overallProgress * 100))%")
                                .font(.system(size: 18, weight: .bold, design: .rounded))
                                .foregroundStyle(AppTheme.primaryGradient)
                        }
                        AnimatedProgressBar(
                            progress: overallProgress,
                            height: 12,
                            gradient: AppTheme.primaryGradient
                        )
                    }
                }
                
                // Total Credits
                HStack(spacing: 12) {
                    GlassCard(padding: 14) {
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundStyle(AppTheme.warmGradient)
                            Text("\(subjects.reduce(0) { $0 + $1.credits }) Credits")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    GlassCard(padding: 14) {
                        HStack {
                            Image(systemName: "text.book.closed.fill")
                                .foregroundStyle(AppTheme.coolGradient)
                            Text("\(subjects.reduce(0) { $0 + $1.completedChapters })/\(subjects.reduce(0) { $0 + $1.totalChapters }) Ch.")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                // Subject Cards
                VStack(spacing: 12) {
                    ForEach(Array(subjects.enumerated()), id: \.element.id) { index, subject in
                        SubjectCard(subject: subject, delay: Double(index) * 0.08)
                    }
                }
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background)
    }
}

private struct SubjectCard: View {
    let subject: Subject
    let delay: Double
    @State private var appear = false
    
    private var gradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: subject.color), Color(hex: subject.color).opacity(0.7)],
            startPoint: .topLeading, endPoint: .bottomTrailing
        )
    }
    
    var body: some View {
        GlassCard {
            VStack(spacing: 14) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(hex: subject.color).opacity(0.15))
                            .frame(width: 48, height: 48)
                        Image(systemName: subject.icon)
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(hex: subject.color))
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(subject.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.textPrimary)
                            .lineLimit(1)
                        
                        HStack(spacing: 8) {
                            Text(subject.code)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(AppTheme.textTertiary)
                            
                            Text("•")
                                .foregroundColor(AppTheme.textTertiary)
                            
                            Text("\(subject.credits) Credits")
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(AppTheme.textTertiary)
                        }
                    }
                    
                    Spacer()
                    
                    Text("\(Int(subject.progress * 100))%")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: subject.color))
                }
                
                HStack(spacing: 10) {
                    AnimatedProgressBar(
                        progress: subject.progress,
                        height: 8,
                        gradient: gradient
                    )
                    
                    Text("\(subject.completedChapters)/\(subject.totalChapters)")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(AppTheme.textTertiary)
                        .frame(width: 30)
                }
            }
        }
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(delay)) {
                appear = true
            }
        }
    }
}
