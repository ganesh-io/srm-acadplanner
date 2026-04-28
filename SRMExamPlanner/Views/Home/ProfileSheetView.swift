import SwiftUI

struct ProfileSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var appear = false
    
    var body: some View {
        ZStack {
            AppTheme.background.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    // Handle
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                    
                    // Avatar
                    ZStack {
                        Circle()
                            .fill(AppTheme.primaryGradient)
                            .frame(width: 90, height: 90)
                        Text("S")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
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
                    .shadow(color: AppTheme.primary.opacity(0.4), radius: 20)
                    .scaleEffect(appear ? 1 : 0.5)
                    .opacity(appear ? 1 : 0)
                    
                    // Name
                    VStack(spacing: 4) {
                        Text("SRM Student")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.textPrimary)
                        Text("B.Tech CSE • 3rd Year")
                            .font(.subheadline)
                            .foregroundColor(AppTheme.textSecondary)
                    }
                    
                    // Stats Row
                    HStack(spacing: 16) {
                        ProfileStat(value: "8.4", label: "CGPA", gradient: AppTheme.primaryGradient)
                        ProfileStat(value: "6", label: "Subjects", gradient: AppTheme.coolGradient)
                        ProfileStat(value: "\(DateHelper.daysUntilExam)", label: "Days Left", gradient: AppTheme.accentGradient)
                    }
                    .padding(.horizontal)
                    
                    // Info Cards
                    VStack(spacing: 12) {
                        ProfileInfoRow(icon: "envelope.fill", label: "Email", value: "student@srmist.edu.in", color: "6366F1")
                        ProfileInfoRow(icon: "building.2.fill", label: "Department", value: "Computer Science & Engg.", color: "06B6D4")
                        ProfileInfoRow(icon: "mappin.circle.fill", label: "Campus", value: "SRM Kattankulathur", color: "F97316")
                        ProfileInfoRow(icon: "studentdesk", label: "Registration", value: "RA2211003XXXXX", color: "10B981")
                    }
                    .padding(.horizontal)
                    
                    // Close Button
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(AppTheme.primaryGradient)
                            )
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                appear = true
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }
}

private struct ProfileStat: View {
    let value: String
    let label: String
    let gradient: LinearGradient
    
    var body: some View {
        GlassCard(padding: 14) {
            VStack(spacing: 6) {
                Text(value)
                    .font(.system(size: 22, weight: .bold, design: .rounded))
                    .foregroundStyle(gradient)
                Text(label)
                    .font(.system(size: 10, weight: .bold))
                    .tracking(1)
                    .foregroundColor(AppTheme.textTertiary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private struct ProfileInfoRow: View {
    let icon: String
    let label: String
    let value: String
    let color: String
    
    var body: some View {
        GlassCard(padding: 14) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: color).opacity(0.15))
                        .frame(width: 40, height: 40)
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: color))
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.caption)
                        .foregroundColor(AppTheme.textTertiary)
                    Text(value)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(AppTheme.textPrimary)
                }
                
                Spacer()
            }
        }
    }
}
