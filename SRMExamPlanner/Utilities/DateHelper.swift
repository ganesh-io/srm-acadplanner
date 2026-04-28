import Foundation

enum DateHelper {
    static func date(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 9
        return Calendar.current.date(from: components) ?? Date()
    }
    
    static var examDate: Date {
        date(year: 2026, month: 5, day: 24)
    }
    
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
}
