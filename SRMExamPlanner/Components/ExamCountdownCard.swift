import SwiftUI

struct ExamCountdownCard: View {
    @State private var countdown = DateHelper.countdown
    @State private var appearAnimation = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GlassCard {
            VStack(spacing: 20) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("EXAM COUNTDOWN")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(2)
                            .foregroundColor(AppTheme.textTertiary)
                        Text("May 24, 2026")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.textPrimary)
                    }
                    Spacer()
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundStyle(AppTheme.accentGradient)
                        .scaleEffect(appearAnimation ? 1.0 : 0.5)
                        .opacity(appearAnimation ? 1.0 : 0)
                }
                
                // Countdown units
                HStack(spacing: 0) {
                    CountdownUnit(value: countdown.days, label: "DAYS",
                                  gradient: AppTheme.primaryGradient)
                    CountdownDivider()
                    CountdownUnit(value: countdown.hours, label: "HRS",
                                  gradient: AppTheme.coolGradient)
                    CountdownDivider()
                    CountdownUnit(value: countdown.minutes, label: "MIN",
                                  gradient: AppTheme.warmGradient)
                    CountdownDivider()
                    CountdownUnit(value: countdown.seconds, label: "SEC",
                                  gradient: AppTheme.accentGradient)
                }
                
                // Semester progress bar
                VStack(spacing: 8) {
                    HStack {
                        Text("Semester Progress")
                            .font(.caption)
                            .foregroundColor(AppTheme.textTertiary)
                        Spacer()
                        Text("\(Int(DateHelper.semesterProgress * 100))%")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(AppTheme.primaryGradient)
                    }
                    AnimatedProgressBar(
                        progress: DateHelper.semesterProgress,
                        height: 6,
                        gradient: AppTheme.primaryGradient
                    )
                }
            }
        }
        .onReceive(timer) { _ in
            withAnimation(.linear(duration: 0.3)) {
                countdown = DateHelper.countdown
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                appearAnimation = true
            }
        }
    }
}

private struct CountdownUnit: View {
    let value: Int
    let label: String
    let gradient: LinearGradient
    
    var body: some View {
        VStack(spacing: 6) {
            Text("\(value)")
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .foregroundStyle(gradient)
                .contentTransition(.numericText())
            Text(label)
                .font(.system(size: 9, weight: .bold))
                .tracking(1.5)
                .foregroundColor(AppTheme.textTertiary)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct CountdownDivider: View {
    var body: some View {
        Text(":")
            .font(.system(size: 24, weight: .bold, design: .rounded))
            .foregroundColor(AppTheme.textTertiary)
            .offset(y: -6)
    }
}
