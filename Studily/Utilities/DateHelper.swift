import Foundation

enum DateHelper {
    // MARK: - Exam Date Configuration
    
    /// The first exam date — May 24, 2026
    static var examDate: Date {
        date(year: 2026, month: 5, day: 24)
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
    
    static var daysUntilExam: Int {
        let calendar = Calendar.current
        let now = calendar.startOfDay(for: Date())
        let exam = calendar.startOfDay(for: examDate)
        return max(0, calendar.dateComponents([.day], from: now, to: exam).day ?? 0)
    }
    
    static var countdown: (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let now = Date()
        let components = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: now, to: examDate)
        return (
            max(0, components.day ?? 0),
            max(0, components.hour ?? 0),
            max(0, components.minute ?? 0),
            max(0, components.second ?? 0)
        )
    }
    
    /// How far through the semester we are (0.0 to 1.0)
    static var semesterProgress: Double {
        let now = Date()
        let totalInterval = examDate.timeIntervalSince(semesterStart)
        let elapsedInterval = now.timeIntervalSince(semesterStart)
        guard totalInterval > 0 else { return 1.0 }
        return min(1.0, max(0.0, elapsedInterval / totalInterval))
    }
    
    /// Weeks remaining until first exam
    static var weeksRemaining: Int {
        return max(0, daysUntilExam / 7)
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
