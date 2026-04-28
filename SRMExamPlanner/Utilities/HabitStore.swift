import Foundation
import Combine

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    
    private let habitsKey = "savedHabits"
    private let dateKey = "lastHabitDate"
    
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
    
    init() {
        loadHabits()
    }
    
    func toggleHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isCompleted.toggle()
            saveHabits()
        }
    }
    
    private func loadHabits() {
        let today = Calendar.current.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: today)
        
        if let savedDate = UserDefaults.standard.string(forKey: dateKey),
           savedDate == todayString,
           let data = UserDefaults.standard.data(forKey: habitsKey),
           let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
            habits = decoded
        } else {
            habits = Habit.defaultHabits
            UserDefaults.standard.set(todayString, forKey: dateKey)
            saveHabits()
        }
    }
    
    private func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: habitsKey)
        }
    }
}
