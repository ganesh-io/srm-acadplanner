import SwiftUI

struct SubjectsView: View {
    @EnvironmentObject var habitStore: HabitStore
    @State private var showAddSheet = false
    
    private var overallProgress: Double {
        guard !habitStore.subjects.isEmpty else { return 0 }
        return habitStore.subjects.reduce(0) { $0 + $1.progress } / Double(habitStore.subjects.count)
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
                    
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundStyle(AppTheme.primaryGradient)
                    }
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
                            Text("\(habitStore.subjects.reduce(0) { $0 + $1.credits }) Credits")
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
                            Text("\(habitStore.subjects.reduce(0) { $0 + $1.completedChapters })/\(habitStore.subjects.reduce(0) { $0 + $1.totalChapters }) Ch.")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.textPrimary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                
                // Subject Cards
                VStack(spacing: 12) {
                    ForEach(Array(habitStore.subjects.enumerated()), id: \.element.id) { index, subject in
                        SubjectCard(subject: subject, delay: Double(index) * 0.08)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    withAnimation {
                                        habitStore.deleteSubject(at: IndexSet(integer: index))
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                    }
                    .onDelete { offsets in
                        habitStore.deleteSubject(at: offsets)
                    }
                }
            }
            .padding(.horizontal, AppTheme.paddingMedium)
            .padding(.bottom, 100)
        }
        .background(AppTheme.background)
        .sheet(isPresented: $showAddSheet) {
            AddSubjectSheet()
                .environmentObject(habitStore)
        }
    }
}

// MARK: - Add Subject Sheet

private struct AddSubjectSheet: View {
    @EnvironmentObject var habitStore: HabitStore
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var selectedColor = "6366F1"
    
    private let colorOptions = ["6366F1", "8B5CF6", "06B6D4", "F43F5E", "10B981", "F97316", "FBBF24", "818CF8"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppTheme.background.ignoresSafeArea()
                
                VStack(spacing: 24) {
                    // Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("SUBJECT NAME")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1.5)
                            .foregroundColor(AppTheme.textTertiary)
                        
                        TextField("e.g. Physics", text: $name)
                            .font(.body)
                            .foregroundColor(AppTheme.textPrimary)
                            .padding()
                            .background(AppTheme.cardBackground)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(AppTheme.cardBorder, lineWidth: 1))
                    }
                    
                    // Color picker
                    VStack(alignment: .leading, spacing: 8) {
                        Text("COLOR")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1.5)
                            .foregroundColor(AppTheme.textTertiary)
                        
                        HStack(spacing: 12) {
                            ForEach(colorOptions, id: \.self) { hex in
                                Circle()
                                    .fill(Color(hex: hex))
                                    .frame(width: 36, height: 36)
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: selectedColor == hex ? 3 : 0)
                                    )
                                    .scaleEffect(selectedColor == hex ? 1.15 : 1.0)
                                    .onTapGesture {
                                        withAnimation(.spring(response: 0.3)) { selectedColor = hex }
                                    }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(24)
            }
            .navigationTitle("Add Subject")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(AppTheme.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        habitStore.addSubject(name: name, color: selectedColor)
                        dismiss()
                    }
                    .fontWeight(.bold)
                    .foregroundStyle(AppTheme.primaryGradient)
                    .disabled(name.isEmpty)
                }
            }
        }
        .presentationDetents([.medium])
    }
}

// MARK: - Subject Card

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
                        
                        if !subject.code.isEmpty {
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
