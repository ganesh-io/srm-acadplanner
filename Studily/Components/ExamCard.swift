import SwiftUI

struct ExamCard: View {
    let exam: Exam
    @State private var appear = false
    
    var body: some View {
        GlassCard {
            HStack(spacing: 14) {
                // Icon circle
                ZStack {
                    Circle()
                        .fill(Color(hex: exam.color).opacity(0.15))
                        .frame(width: 48, height: 48)
                    Image(systemName: exam.icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: exam.color))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(exam.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.textPrimary)
                        .lineLimit(1)
                    Text(exam.subject)
                        .font(.caption)
                        .foregroundColor(AppTheme.textTertiary)
                }
                
                Spacer()
                
                // Days left badge
                VStack(spacing: 2) {
                    Text("\(exam.daysLeft)")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(Color(hex: exam.color))
                    Text("days")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(AppTheme.textTertiary)
                }
                .frame(width: 56)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(hex: exam.color).opacity(0.1))
                )
            }
        }
        .opacity(appear ? 1 : 0)
        .offset(y: appear ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                appear = true
            }
        }
    }
}
