import Foundation

enum DateHelper {
    // MARK: - Dynamic Exam Date (reads from UserDefaults)
    
    static var examDate: Date? {
        UserDefaults.standard.object(forKey: "examDate") as? Date
    }
    
    /// Semester start date for progress calculation
    static var semesterStart: Date {
        date(year: 2026, month: 1, day: 6)
    }
    
    // MARK: - Date Construction
    
    static func date(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 9
        return Calendar.current.date(from: components) ?? Date()
    }
    
    // MARK: - Countdown Calculations
    
    static var daysUntilExam: Int? {
        guard let exam = examDate else { return nil }
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let examDay = calendar.startOfDay(for: exam)
        return max(0, calendar.dateComponents([.day], from: now, to: examDay).day ?? 0)
    }
    
    static var countdown: (days: Int, hours: Int, minutes: Int, seconds: Int)? {
        guard let exam = examDate else { return nil }
        let now = Date()
        guard exam > now else { return (0, 0, 0, 0) }
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: exam)
        return (
            max(0, components.day ?? 0),
            max(0, components.hour ?? 0),
            max(0, components.minute ?? 0),
            max(0, components.second ?? 0)
        )
    }
    
    /// How far through the semester we are (0.0 to 1.0)
    static var semesterProgress: Double? {
        guard let exam = examDate else { return nil }
        let now = Date()
        let totalInterval = exam.timeIntervalSince(semesterStart)
        let elapsedInterval = now.timeIntervalSince(semesterStart)
        guard totalInterval > 0 else { return 1.0 }
        return min(1.0, max(0.0, elapsedInterval / totalInterval))
    }
    
    /// Weeks remaining until first exam
    static var weeksRemaining: Int? {
        guard let days = daysUntilExam else { return nil }
        return max(0, days / 7)
    }
    
    // MARK: - Utility
    
    static func daysLeft(to date: Date) -> Int {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let target = calendar.startOfDay(for: date)
        return calendar.dateComponents([.day], from: now, to: target).day ?? 0
    }
    
    static func formatShortDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    static func formatFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: date)
    }
}
