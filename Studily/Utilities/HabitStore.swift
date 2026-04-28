import Foundation
import Combine

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var streak: Int = 0
    
    private let habitsKey = "savedHabits"
    private let dateKey = "lastHabitDate"
    private let streakKey = "habitStreak"
    private let lastCompletedDateKey = "lastCompletedDate"
    
    var completedCount: Int {
        habits.filter(\.isCompleted).count
    }
    
    var totalCount: Int {
        habits.count
    }
    
    var completionPercentage: Double {
        guard totalCount > 0 else { return 0 }
        return Double(completedCount) / Double(totalCount)
    }
    
    var isAllComplete: Bool {
        completedCount == totalCount && totalCount > 0
    }
    
    init() {
        loadHabits()
        loadStreak()
    }
    
    func toggleHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isCompleted.toggle()
            saveHabits()
            
            // Update streak when all habits are completed
            if isAllComplete {
                updateStreak()
            }
        }
    }
    
    // MARK: - Persistence
    
    private func loadHabits() {
        let today = Calendar.current.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: today)
        
        if let savedDate = UserDefaults.standard.string(forKey: dateKey),
           savedDate == todayString,
           let data = UserDefaults.standard.data(forKey: habitsKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            // Same day — restore saved state (persists across background/foreground)
            habits = decoded
        } else {
            // New day or first launch — reset all habits
            habits = Habit.defaultHabits
            UserDefaults.standard.set(todayString, forKey: dateKey)
            saveHabits()
            
            // Check if streak should be broken (missed yesterday)
            checkStreakContinuity()
        }
    }
    
    private func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: habitsKey)
        }
    }
    
    // MARK: - Streak Tracking
    
    private func loadStreak() {
        streak = UserDefaults.standard.integer(forKey: streakKey)
    }
    
    private func updateStreak() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date())
        
        // Only increment streak once per day
        if UserDefaults.standard.string(forKey: lastCompletedDateKey) != todayString {
            streak += 1
            UserDefaults.standard.set(streak, forKey: streakKey)
            UserDefaults.standard.set(todayString, forKey: lastCompletedDateKey)
        }
    }
    
    private func checkStreakContinuity() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let lastDateString = UserDefaults.standard.string(forKey: lastCompletedDateKey),
              let lastDate = formatter.date(from: lastDateString) else {
            return
        }
        
        let calendar = Calendar.current
        let yesterday = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date()))!
        
        // If last completed date is before yesterday, streak is broken
        if lastDate < yesterday {
            streak = 0
            UserDefaults.standard.set(0, forKey: streakKey)
        }
    }
}
