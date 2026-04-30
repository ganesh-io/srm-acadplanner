import Foundation
import Combine
import UserNotifications

class HabitStore: ObservableObject {
    @Published var habits: [Habit] = []
    @Published var streak: Int = 0
    @Published var subjects: [Subject] = []
    @Published var examDate: Date? = nil
    @Published var dailyReminderEnabled: Bool = false
    
    private let habitsKey = "savedHabits"
    private let dateKey = "lastHabitDate"
    private let streakKey = "habitStreak"
    private let lastCompletedDateKey = "lastCompletedDate"
    private let subjectsKey = "savedSubjects"
    private let examDateKey = "examDate"
    private let reminderKey = "dailyReminderEnabled"
    private let lastResetDateKey = "lastResetDate"
    
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
        loadSubjects()
        loadExamDate()
        loadReminderPref()
        
        // Listen for significant time changes (midnight, timezone, etc.)
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleTimeChange),
            name: UIApplication.significantTimeChangeNotification, object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleTimeChange() {
        checkMidnightReset()
    }
    
    // MARK: - Midnight Reset
    
    func checkMidnightReset() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        if let lastReset = UserDefaults.standard.object(forKey: lastResetDateKey) as? Date {
            let lastResetDay = calendar.startOfDay(for: lastReset)
            if today > lastResetDay {
                // New day: reset all habit completions
                for i in habits.indices {
                    habits[i].isCompleted = false
                }
                saveHabits()
                checkStreakContinuity()
                UserDefaults.standard.set(today, forKey: lastResetDateKey)
            }
        } else {
            // First time: store today
            UserDefaults.standard.set(today, forKey: lastResetDateKey)
        }
    }
    
    // MARK: - Habits
    
    func toggleHabit(_ habit: Habit) {
        if let index = habits.firstIndex(where: { $0.id == habit.id }) {
            habits[index].isCompleted.toggle()
            saveHabits()
            
            if isAllComplete {
                updateStreak()
            }
        }
    }
    
    // MARK: - Subjects
    
    func addSubject(name: String, color: String) {
        let subject = Subject(
            name: name, code: "", icon: "book.fill",
            color: color, progress: 0.0, totalChapters: 10,
            completedChapters: 0, credits: 3
        )
        subjects.append(subject)
        saveSubjects()
    }
    
    func deleteSubject(at offsets: IndexSet) {
        subjects.remove(atOffsets: offsets)
        saveSubjects()
    }
    
    func updateSubjectProgress(_ subject: Subject, progress: Double) {
        if let idx = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[idx].progress = progress
            subjects[idx].completedChapters = Int(progress * Double(subjects[idx].totalChapters))
            saveSubjects()
        }
    }
    
    // MARK: - Exam Date
    
    func setExamDate(_ date: Date) {
        examDate = date
        UserDefaults.standard.set(date, forKey: examDateKey)
        // Reschedule exam alert
        NotificationHelper.scheduleExamAlert(for: date)
    }
    
    // MARK: - Daily Reminder
    
    func setDailyReminder(_ enabled: Bool) {
        dailyReminderEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: reminderKey)
        if enabled {
            NotificationHelper.scheduleDailyReminder()
        } else {
            NotificationHelper.cancelDailyReminder()
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
            habits = decoded
        } else {
            habits = Habit.defaultHabits
            UserDefaults.standard.set(todayString, forKey: dateKey)
            saveHabits()
            checkStreakContinuity()
        }
    }
    
    private func saveHabits() {
        if let data = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(data, forKey: habitsKey)
        }
    }
    
    private func loadSubjects() {
        if let data = UserDefaults.standard.data(forKey: subjectsKey),
           let decoded = try? JSONDecoder().decode([Subject].self, from: data) {
            subjects = decoded
        } else {
            subjects = Subject.defaultSubjects
            saveSubjects()
        }
    }
    
    private func saveSubjects() {
        if let data = try? JSONEncoder().encode(subjects) {
            UserDefaults.standard.set(data, forKey: subjectsKey)
        }
    }
    
    private func loadExamDate() {
        examDate = UserDefaults.standard.object(forKey: examDateKey) as? Date
    }
    
    private func loadReminderPref() {
        dailyReminderEnabled = UserDefaults.standard.bool(forKey: reminderKey)
    }
    
    // MARK: - Streak Tracking
    
    private func loadStreak() {
        streak = UserDefaults.standard.integer(forKey: streakKey)
    }
    
    private func updateStreak() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date())
        
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
        
        if lastDate < yesterday {
            streak = 0
            UserDefaults.standard.set(0, forKey: streakKey)
        }
    }
}
